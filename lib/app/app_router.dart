import 'package:auto_route/auto_route.dart';
import 'package:finance_app/presentation/create_transaction/ui/pages/new_create_transactions_page.dart';
import 'package:finance_app/presentation/onboarding/ui/pages/onboarding_page.dart';
import 'package:finance_app/presentation/splash/ui/pages/splash_page.dart';
import 'package:finance_app/presentation/survey/ui/pages/survey_page.dart';
import 'package:finance_app/presentation/tab_bar/ui/page/tab_bar_page.dart';
import 'package:finance_app/presentation/transaction_category_list/ui/page/transactions_category.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: OnboardingRoute.page),
    AutoRoute(page: SurveyRoute.page),
    AutoRoute(page: TabBarRoute.page),
    AutoRoute(page: NewCreateTransactionsRoute.page),
    AutoRoute(page: TransactionsCategoryRoute.page),
  ];
}
