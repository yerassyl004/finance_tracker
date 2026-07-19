// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [NewCreateTransactionsPage]
class NewCreateTransactionsRoute
    extends PageRouteInfo<NewCreateTransactionsRouteArgs> {
  NewCreateTransactionsRoute({
    Key? key,
    required CreateTransactionsArgument? args,
    List<PageRouteInfo>? children,
  }) : super(
         NewCreateTransactionsRoute.name,
         args: NewCreateTransactionsRouteArgs(key: key, args: args),
         initialChildren: children,
       );

  static const String name = 'NewCreateTransactionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewCreateTransactionsRouteArgs>();
      return NewCreateTransactionsPage(key: args.key, args: args.args);
    },
  );
}

class NewCreateTransactionsRouteArgs {
  const NewCreateTransactionsRouteArgs({this.key, required this.args});

  final Key? key;

  final CreateTransactionsArgument? args;

  @override
  String toString() {
    return 'NewCreateTransactionsRouteArgs{key: $key, args: $args}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NewCreateTransactionsRouteArgs) return false;
    return key == other.key && args == other.args;
  }

  @override
  int get hashCode => key.hashCode ^ args.hashCode;
}

/// generated route for
/// [OnboardingPage]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [SurveyPage]
class SurveyRoute extends PageRouteInfo<void> {
  const SurveyRoute({List<PageRouteInfo>? children})
    : super(SurveyRoute.name, initialChildren: children);

  static const String name = 'SurveyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SurveyPage();
    },
  );
}

/// generated route for
/// [TabBarPage]
class TabBarRoute extends PageRouteInfo<void> {
  const TabBarRoute({List<PageRouteInfo>? children})
    : super(TabBarRoute.name, initialChildren: children);

  static const String name = 'TabBarRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TabBarPage();
    },
  );
}

/// generated route for
/// [TransactionsCategoryPage]
class TransactionsCategoryRoute
    extends PageRouteInfo<TransactionsCategoryRouteArgs> {
  TransactionsCategoryRoute({
    Key? key,
    required TransactionsCategoryArguments args,
    List<PageRouteInfo>? children,
  }) : super(
         TransactionsCategoryRoute.name,
         args: TransactionsCategoryRouteArgs(key: key, args: args),
         initialChildren: children,
       );

  static const String name = 'TransactionsCategoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionsCategoryRouteArgs>();
      return TransactionsCategoryPage(key: args.key, args: args.args);
    },
  );
}

class TransactionsCategoryRouteArgs {
  const TransactionsCategoryRouteArgs({this.key, required this.args});

  final Key? key;

  final TransactionsCategoryArguments args;

  @override
  String toString() {
    return 'TransactionsCategoryRouteArgs{key: $key, args: $args}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionsCategoryRouteArgs) return false;
    return key == other.key && args == other.args;
  }

  @override
  int get hashCode => key.hashCode ^ args.hashCode;
}
