import 'package:finance_app/app/di.dart';
import 'package:finance_app/domain/models/account.dart';
import 'package:finance_app/presentation/accounts_page/bloc/accounts_bloc.dart';
import 'package:finance_app/presentation/accounts_page/di.dart';
import 'package:finance_app/presentation/accounts_page/ui/widget/accounts_list.dart';
import 'package:finance_app/presentation/create_account/ui/page/create_account_page.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.getAccountsBloc()..add(AccountsEvent.loadAccounts()),
      child: const AccountsPageView(),
    );
  }
}

class AccountsPageView extends StatefulWidget {
  const AccountsPageView({super.key});

  @override
  State<AccountsPageView> createState() => _AccountsPageViewState();
}

class _AccountsPageViewState extends State<AccountsPageView> {
  /// Last successfully loaded accounts, kept so a reload (delete / add / manual
  /// refresh) keeps the list on screen with a subtle progress line instead of
  /// blanking to a skeleton on every `loading` emission. Presentation-only —
  /// the BLoC is untouched.
  List<Account>? _lastAccounts;

  /// Opens the create/edit account sheet and reloads on a successful save.
  /// Same behaviour as before — only the sheet surface styling changed.
  Future<void> _openAccountSheet(
    BuildContext context, {
    Account? account,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: HomeSpacing.md,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: HomeTokens.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(HomeTokens.radiusLg),
              ),
            ),
            child: FractionallySizedBox(
              heightFactor: 0.95,
              child: account == null
                  ? CreateAccountPage()
                  : CreateAccountPage(
                      args: CreateAccountPageArguments(account: account),
                    ),
            ),
          ),
        );
      },
    );

    if (context.mounted && result == true) {
      context.read<AccountsBloc>().add(AccountsEvent.loadAccounts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeTokens.background,
      body: BlocBuilder<AccountsBloc, AccountsState>(
        // Freezed states have value equality, so identical emissions are skipped.
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is AccountsLoaded) {
            _lastAccounts = state.accounts;
          }
          final accounts = state.maybeWhen(
            loaded: (a) => a,
            orElse: () => _lastAccounts,
          );
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AccountsHeader(count: accounts?.length),
                    _RefreshBar(visible: isLoading),
                    Expanded(
                      child: _AccountsBody(
                        state: state,
                        accounts: accounts,
                        onRefresh: () {
                          context.read<AccountsBloc>().add(
                            AccountsEvent.loadAccounts(),
                          );
                        },
                        onDelete: (account) {
                          context.read<AccountsBloc>().add(
                            AccountsEvent.deleteAccount(account),
                          );
                        },
                        onEdit: (account) =>
                            _openAccountSheet(context, account: account),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: HomeSpacing.md,
                  right: HomeSpacing.md,
                  bottom: HomeSpacing.md,
                  child: _AddAccountButton(
                    onTap: () => _openAccountSheet(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Left-aligned screen title with an optional muted account count.
class _AccountsHeader extends StatelessWidget {
  final int? count;
  const _AccountsHeader({this.count});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            HomeSpacing.md,
            HomeSpacing.md,
            HomeSpacing.md,
            HomeSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.accounts, style: HomeTokens.heading()),
              if (count != null) ...[
                const SizedBox(height: HomeSpacing.xs),
                Text(
                  count == 1 ? '1 account' : '$count accounts',
                  style: HomeTokens.bodyMuted(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Chooses skeleton / list / empty / error and cross-fades between them. While
/// reloading, [accounts] is the cached previous list, so the list stays mounted
/// and only updates in place — no skeleton flash on delete or refresh.
class _AccountsBody extends StatelessWidget {
  final AccountsState state;
  final List<Account>? accounts;
  final VoidCallback onRefresh;
  final Function(Account) onDelete;
  final Function(Account) onEdit;

  const _AccountsBody({
    required this.state,
    required this.accounts,
    required this.onRefresh,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final accounts = this.accounts;
    final Widget child = state.maybeWhen(
      error: (message) => _AccountsErrorState(message: message),
      orElse: () {
        if (accounts == null) return const _AccountsLoadingSkeleton();
        if (accounts.isEmpty) return const _AccountsEmptyState();
        return AccountsList(
          key: const ValueKey('accounts'),
          accounts: accounts,
          updateList: onRefresh,
          deleteAccount: onDelete,
          pushEditAccount: onEdit,
        );
      },
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

/// Slim, low-emphasis progress line under the title while a reload is in flight.
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

/// Full-width accent action, sharing the Home add button's interaction language
/// (accent surface, [HomeTokens.radiusMd], Material + InkWell). Keeps the exact
/// create-account flow via [onTap].
class _AddAccountButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddAccountButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: Material(
          color: HomeTokens.accent,
          elevation: 2,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
          child: InkWell(
            borderRadius: BorderRadius.circular(HomeTokens.radiusMd),
            onTap: onTap,
            child: SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 22, color: HomeTokens.surface),
                  const SizedBox(width: HomeSpacing.sm),
                  Text(
                    AppStrings.addNewAccount,
                    style: HomeTokens.body().copyWith(
                      color: HomeTokens.surface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty-state placeholder pointing the user at the add action.
class _AccountsEmptyState extends StatelessWidget {
  const _AccountsEmptyState();

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
                Icons.account_balance_wallet_outlined,
                size: 34,
                color: HomeTokens.accent,
              ),
            ),
            const SizedBox(height: HomeSpacing.lg),
            Text(
              'No accounts yet',
              style: HomeTokens.heading(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HomeSpacing.sm),
            Text(
              'Tap “${AppStrings.addNewAccount}” below to create your first one.',
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

/// Calm, surfaced error card (no raw red text dump).
class _AccountsErrorState extends StatelessWidget {
  final String message;
  const _AccountsErrorState({required this.message});

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

/// Loading placeholder mirroring the real tile layout for a stable transition.
class _AccountsLoadingSkeleton extends StatelessWidget {
  const _AccountsLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('loading'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: HomeTokens.contentMaxWidth),
        child: ListView.separated(
          padding: const EdgeInsets.all(HomeSpacing.md),
          itemCount: 4,
          separatorBuilder: (_, __) =>
              const SizedBox(height: HomeSpacing.sm + HomeSpacing.xs),
          itemBuilder: (context, index) => const HomeCard(
            padding: EdgeInsets.symmetric(
              horizontal: HomeSpacing.md,
              vertical: HomeSpacing.md,
            ),
            child: Row(
              children: [
                Skeleton(width: 48, height: 48, radius: HomeTokens.radiusMd),
                SizedBox(width: HomeSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(width: 120, height: 14),
                      SizedBox(height: HomeSpacing.sm),
                      Skeleton(width: 60, height: 11),
                    ],
                  ),
                ),
                SizedBox(width: HomeSpacing.md),
                Skeleton(width: 72, height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
