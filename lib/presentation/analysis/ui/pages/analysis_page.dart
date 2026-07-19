import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/app/di.dart';
import 'package:finance_app/presentation/analysis/bloc/analysis_bloc.dart';
import 'package:finance_app/presentation/analysis/di.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/ai_insights_card.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/analysis_theme.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/category_budgets_card.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/transaction_analys_list.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/analys_header_widget.dart';
import 'package:finance_app/presentation/analysis/ui/widgets/multi_segment_circular_percent_indicator.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getAnalysisBloc(),
      child: AnalysisPageView(),
    );
  }
}

class AnalysisPageView extends StatefulWidget {
  const AnalysisPageView({super.key});

  @override
  State<AnalysisPageView> createState() => _AnalysisPageViewState();
}

class _AnalysisPageViewState extends State<AnalysisPageView> {
  /// The last fully-loaded data, kept so a reload (e.g. changing month) shows
  /// the previous content with a subtle progress line instead of blanking the
  /// whole screen to a spinner.
  AnalysisData? _lastData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      // Freezed states have value equality, so identical emissions are skipped.
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final loaded = state.mapOrNull(loaded: (s) => s.data);
        if (loaded != null) _lastData = loaded;

        final loadingData = state.mapOrNull(loading: (s) => s.data);
        final isRefreshing = loadingData != null;

        var display = _lastData;
        // While reloading, update the header's month immediately for snappy
        // navigation while the body keeps showing the previous content.
        if (display != null && loadingData != null) {
          display = display.copyWith(currentMonth: loadingData.currentMonth);
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: display == null
              ? const _AnalysisLoadingView(key: ValueKey('loading'))
              : _AnalysisLoadedView(
                  key: const ValueKey('loaded'),
                  data: display,
                  isRefreshing: isRefreshing,
                ),
        );
      },
    );
  }
}

/// Neutral, centered loading state (previously the screen was blank until the
/// first load completed).
class _AnalysisLoadingView extends StatelessWidget {
  const _AnalysisLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AnalysisTokens.background,
      body: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AnalysisTokens.accent,
          ),
        ),
      ),
    );
  }
}

class _AnalysisLoadedView extends StatelessWidget {
  final AnalysisData data;
  final bool isRefreshing;

  const _AnalysisLoadedView({
    super.key,
    required this.data,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AnalysisTokens.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                AnalysHeaderWidget(
                  onDateChanged: (date) {
                    context.read<AnalysisBloc>().add(
                      AnalysisEvent.updateTransactions(
                        month: date,
                        typeSpending: data.selectedType,
                      ),
                    );
                  },
                  typeSpending: (selectedType) {
                    context.read<AnalysisBloc>().add(
                      AnalysisEvent.updateTransactions(
                        month: data.currentMonth,
                        typeSpending: selectedType,
                      ),
                    );
                  },
                  currentDate: data.currentMonth,
                  selectedType: data.selectedType,
                ),
                // Subtle top progress line shown while a reload is in flight,
                // so navigation feels responsive without blanking the page.
                SizedBox(
                  height: 2,
                  child: isRefreshing
                      ? LinearProgressIndicator(
                          minHeight: 2,
                          backgroundColor: Colors.transparent,
                          color: AnalysisTokens.accent,
                        )
                      : null,
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AnalysisTokens.contentMaxWidth,
                      ),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.md,
                                AppSpacing.md,
                                AppSpacing.md,
                                0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _SpendingChartCard(data: data),
                                  const SizedBox(height: AppSpacing.md),
                                  CategoryBudgetsCard(data: data),
                                  const SizedBox(height: AppSpacing.md),
                                  AiInsightsCard(data: data),
                                  const SizedBox(height: AppSpacing.lg),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: AppSpacing.xs,
                                      bottom: AppSpacing.sm,
                                    ),
                                    child: Text(
                                      AppStrings.records,
                                      style: AnalysisTokens.label(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TransactionAnalysList(
                            dateTime: data.currentMonth,
                            analysisList: data.analysis,
                          ),
                          // Clearance so the FAB never covers the last row.
                          const SliverToBoxAdapter(child: SizedBox(height: 96)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: AppSpacing.md,
            bottom: AppSpacing.lg,
            child: _AddTransactionButton(),
          ),
        ],
      ),
    );
  }
}

/// The category donut wrapped in the shared card surface.
class _SpendingChartCard extends StatelessWidget {
  final AnalysisData data;

  const _SpendingChartCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return AnalysisCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.categories,
              style: AnalysisTokens.cardTitle(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          MultiSegmentCircularPercentIndicator(segments: data.segments),
        ],
      ),
    );
  }
}

/// Plain accent "add" button positioned in the page [Stack] (no FAB). Reads the
/// BLoC at tap time and takes no build-time inputs, so it's `const` and never
/// rebuilds with the rest of the page.
class _AddTransactionButton extends StatelessWidget {
  const _AddTransactionButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AnalysisTokens.accent,
      borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(AnalysisTokens.radiusMd),
        onTap: () async {
          final result = await context.pushRoute(
            NewCreateTransactionsRoute(args: null),
          );
          if (context.mounted && result == true) {
            context.read<AnalysisBloc>().add(LoadTransactions());
          }
        },
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(Icons.add, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
