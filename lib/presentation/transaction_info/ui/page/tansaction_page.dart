import 'package:finance_app/app/di.dart';
import 'package:finance_app/domain/models/transaction.dart';
import 'package:finance_app/domain/models/type_spending.dart';
import 'package:finance_app/presentation/resourses/app_tokens.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/transaction_info/bloc/transaction_info_bloc.dart';
import 'package:finance_app/presentation/transaction_info/di.dart';
import 'package:finance_app/presentation/transaction_info/ui/widget/account_info_widget.dart';
import 'package:finance_app/presentation/transaction_info/ui/widget/destination_widget.dart';
import 'package:finance_app/presentation/transaction_info/ui/widget/header_detail_widget.dart';
import 'package:finance_app/presentation/transaction_info/ui/widget/transfer_note_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TansactionInfoArgument {
  final Transaction transaction;

  const TansactionInfoArgument({required this.transaction});
}

class TansactionPage extends StatelessWidget {
  final TansactionInfoArgument args;
  const TansactionPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getTransactionInfoBloc(args.transaction)
        ..add(
          TransactionInfoEvent.show(
            data: TransactionInfoData(transaction: args.transaction),
          ),
        ),
      child: TansactionPageView(args: args),
    );
  }
}

class TansactionPageView extends StatelessWidget {
  final TansactionInfoArgument args;
  TansactionPageView({super.key, required this.args});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = args.transaction.note ?? '';
    return BlocBuilder<TransactionInfoBloc, TransactionInfoState>(
      builder: (context, state) {
        return state.maybeWhen(
          show: (data) {
            final transaction = data.transaction;
            final isTransfer =
                transaction.typeSpending == TypeSpending.transfer;
            return Container(
              color: HomeTokens.surface,
              child: SafeArea(
                top: false,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      HomeSpacing.md,
                      HomeSpacing.sm,
                      HomeSpacing.md,
                      HomeSpacing.lg,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _GrabHandle(),
                        const SizedBox(height: HomeSpacing.md),
                        HeaderDetailWidget(
                          transaction: transaction,
                          onDelete: () {
                            context.read<TransactionInfoBloc>().add(
                              TransactionInfoEvent.remove(data: data),
                            );
                          },
                        ),
                        const SizedBox(height: HomeSpacing.lg),
                        _SectionLabel(AppStrings.account),
                        const SizedBox(height: HomeSpacing.sm),
                        AccountInfoWidget(account: transaction.account!),
                        if (isTransfer)
                          DestinationWidget(
                            destination: transaction.destination,
                          ),
                        const SizedBox(height: HomeSpacing.lg),
                        _SectionLabel(AppStrings.note),
                        const SizedBox(height: HomeSpacing.sm),
                        TransferNoteWidget(controller: _controller),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}

/// Drag affordance at the top of the sheet.
class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: HomeTokens.track,
          borderRadius: BorderRadius.circular(HomeTokens.radiusPill),
        ),
      ),
    );
  }
}

/// Small uppercase section label.
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: HomeTokens.label());
  }
}
