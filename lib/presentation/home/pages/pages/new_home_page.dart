import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/app/di.dart';
import 'package:finance_app/presentation/home/bloc/transaction_bloc.dart';
import 'package:finance_app/presentation/home/di.dart';
import 'package:finance_app/presentation/home/widgets/header_widget.dart';
import 'package:finance_app/presentation/home/widgets/transactions_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewHomePage extends StatelessWidget {
  const NewHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getHomeBloc(),
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: state.maybeWhen(
              loaded: (data) => HeaderPreferred(
                transactionsFuture: data.transactions,
                onDateChanged: (newDate) {
                  context.read<TransactionBloc>().add(
                    LoadTransactionItems(month: newDate),
                  );
                },
                expenseAmount: data.expenseAmount,
                incomeAmount: data.incomeAmount,
                currentDate: data.currentMonth,
              ),
              orElse: () => null,
            ),

            body: Stack(
              children: [
                Container(color: Colors.grey.shade100),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: state.maybeWhen(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (message) =>
                              Center(child: Text('Error: $message')),
                          loaded: (data) {
                            if (data.transactions.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Center(
                                  child: Text(
                                    'No records in this month. Tap + to add new expense or income',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              return TransactionsList(
                                transactions: data.transactions,
                                scrollController: ScrollController(),
                                updateList: () {
                                  context.read<TransactionBloc>().add(
                                    LoadTransactionItems(
                                      month: data.currentMonth,
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          orElse: () =>
                              Center(child: Text('No transactions found.')),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey.shade300,
                    onPressed: () async {
                      final result = await context.pushRoute(
                        NewCreateTransactionsRoute(args: null),
                      );
                      if (result == true) {
                        state.maybeWhen(
                          loaded: (data) {
                            context.read<TransactionBloc>().add(
                              LoadTransactionItems(month: data.currentMonth),
                            );
                          },
                          orElse: () {},
                        );
                      }
                    },
                    child: const Icon(CupertinoIcons.add),
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
