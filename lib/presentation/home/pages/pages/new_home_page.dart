import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/app/di.dart';
import 'package:finance_app/presentation/home/bloc/transaction_bloc.dart';
import 'package:finance_app/presentation/home/di.dart';
import 'package:finance_app/presentation/home/widgets/header_widget.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/home/widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_app/presentation/resourses/shared_month.dart';

class NewHomePage extends StatelessWidget {
  const NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getHomeBloc(),
      child: const _HomeView(),
    );
  }
}

/// Stateful shell so the [ScrollController] and the last-loaded data survive
/// across rebuilds. Switching months makes the BLoC emit `loading()` (which
/// carries no data); caching the previous [TransactionData] lets the header and
/// list stay on screen with a subtle refresh bar instead of flashing away to a
/// full-screen skeleton on every month change.
class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final ScrollController _scrollController = ScrollController();
  TransactionData? _lastData;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      // Freezed states have value equality, so identical emissions are skipped.
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        // Keep the last successful data warm so the next transient loading /
        // error state can keep rendering the header and list in place.
        if (state is TransactionLoaded) {
          _lastData = state.data;
        }
        final data = state.maybeWhen(loaded: (d) => d, orElse: () => _lastData);
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: HomeTokens.background,
          appBar: data == null
              ? null
              : HeaderPreferred(
                  transactionsFuture: data.transactions,
                  onDateChanged: (newDate) {
                    SharedMonth.currentMonth = newDate;
                    context.read<TransactionBloc>().add(
                      LoadTransactionItems(month: newDate),
                    );
                  },
                  expenseAmount: data.expenseAmount,
                  incomeAmount: data.incomeAmount,
                  currentDate: data.currentMonth,
                ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _RefreshBar(visible: isLoading),
                    Expanded(
                      child: _HomeBody(
                        state: state,
                        data: data,
                        scrollController: _scrollController,
                        onRefresh: () {
                          final month = data?.currentMonth ?? DateTime.now();
                          context.read<TransactionBloc>().add(
                            LoadTransactionItems(month: month),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Overlaid in the Stack instead of Scaffold.floatingActionButton
                // so it participates in the body layout directly.
                const Positioned(
                  right: HomeSpacing.lg,
                  bottom: HomeSpacing.lg,
                  child: _AddTransactionButton(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Decides between skeleton / list / empty / error and cross-fades between them.
/// When a month change is loading, [data] is the cached previous result, so the
/// list stays mounted (same key + persistent controller) and only updates in
/// place — no skeleton flash, no lost scroll position.
class _HomeBody extends StatelessWidget {
  final TransactionState state;
  final TransactionData? data;
  final ScrollController scrollController;
  final VoidCallback onRefresh;

  const _HomeBody({
    required this.state,
    required this.data,
    required this.scrollController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.data;
    final Widget child = state.maybeWhen(
      error: (message) => _HomeErrorState(message: message),
      orElse: () {
        if (data == null) return const _HomeLoadingSkeleton();
        if (data.transactions.isEmpty) return const _HomeEmptyState();
        return TransactionsList(
          key: const ValueKey('transactions'),
          transactions: data.transactions,
          scrollController: scrollController,
          updateList: onRefresh,
        );
      },
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

/// Slim, low-emphasis progress line under the header, shown while a month is
/// (re)loading. Occupies a fixed height so nothing below it jumps.
class _RefreshBar extends StatelessWidget {
  final bool visible;
  const _RefreshBar({required this.visible});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: LinearProgressIndicator(
          minHeight: 3,
          color: HomeTokens.accent,
          backgroundColor: HomeTokens.track,
        ),
      ),
    );
  }
}

/// The add button reads the current month from the BLoC at press time, so it
/// carries no build-time dependency on state and never rebuilds.
class _AddTransactionButton extends StatelessWidget {
  const _AddTransactionButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Add transaction',
      child: Material(
        color: HomeTokens.accent,
        elevation: 2,
        borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          onTap: () async {
            final bloc = context.read<TransactionBloc>();
            final result = await context.pushRoute(
              NewCreateTransactionsRoute(args: null),
            );
            if (result == true) {
              bloc.state.maybeWhen(
                loaded: (data) {
                  bloc.add(LoadTransactionItems(month: data.currentMonth));
                },
                orElse: () {},
              );
            }
          },
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add, size: 28, color: HomeTokens.surface),
          ),
        ),
      ),
    );
  }
}

/// Empty-state placeholder: a soft accent glyph, a short headline and a hint
/// pointing the user at the + button. Drives off the same `loaded`/`orElse`
/// states as before — no BLoC change.
class _HomeEmptyState extends StatelessWidget {
  static const String message =
      'No records this month. Tap + to add an expense or income.';
  const _HomeEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: const EdgeInsets.all(HomeSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: HomeTokens.accentSoft,
                borderRadius: BorderRadius.circular(HomeTokens.radiusLg),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 34,
                color: HomeTokens.accent,
              ),
            ),
            const SizedBox(height: HomeSpacing.lg),
            Text(
              'Nothing here yet',
              style: HomeTokens.heading(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HomeSpacing.sm),
            Text(
              message,
              style: HomeTokens.bodyMuted(),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state: a calm surfaced card rather than raw red text.
class _HomeErrorState extends StatelessWidget {
  final String message;
  const _HomeErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(HomeSpacing.lg),
        child: HomeCard(
          padding: const EdgeInsets.all(HomeSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: HomeTokens.danger,
              ),
              const SizedBox(height: HomeSpacing.md),
              Text(
                'Something went wrong',
                style: HomeTokens.metricMedium(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: HomeSpacing.sm),
              Text(
                message,
                style: HomeTokens.bodyMuted(),
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton shown while transactions load — mirrors the real list layout so the
/// transition into content is calm and layout-stable.
class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('loading'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: ListView.builder(
          padding: const EdgeInsets.all(HomeSpacing.md),
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : HomeSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.only(
                    left: HomeSpacing.xs,
                    bottom: HomeSpacing.sm,
                  ),
                  child: Skeleton(width: 140, height: 12),
                ),
                HomeCard(
                  padding: EdgeInsets.symmetric(
                    vertical: HomeSpacing.md,
                    horizontal: HomeSpacing.md,
                  ),
                  child: Column(
                    children: [
                      _SkeletonRow(),
                      SizedBox(height: HomeSpacing.md),
                      _SkeletonRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Skeleton(width: 44, height: 44, radius: HomeTokens.radiusMd),
        SizedBox(width: HomeSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(width: 120, height: 13),
              SizedBox(height: HomeSpacing.sm),
              Skeleton(width: 80, height: 11),
            ],
          ),
        ),
        SizedBox(width: HomeSpacing.md),
        Skeleton(width: 64, height: 14),
      ],
    );
  }
}
