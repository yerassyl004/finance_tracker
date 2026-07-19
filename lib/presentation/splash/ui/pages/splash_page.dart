import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/app/di.dart';
import 'package:finance_app/app/services/notification_service.dart';
import 'package:finance_app/domain/usecases.dart/financial_profile/load_financial_profile_usecase.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:flutter/material.dart';

/// Startup gate: decides whether to show the required onboarding + survey
/// flow or go straight to the app, based on whether a financial profile
/// has already been captured.
@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _decideStartDestination();
    _setupReminders();
  }

  /// Asks for notification permission and, if granted, (re)schedules the daily
  /// reminders. Runs independently of navigation and never blocks startup.
  Future<void> _setupReminders() async {
    final service = getIt<NotificationService>();
    final granted = await service.requestPermissions();
    if (granted) {
      await service.scheduleDailyReminders();
    }
  }

  Future<void> _decideStartDestination() async {
    final result = await getIt<LoadFinancialProfileUsecase>().execute(null);
    if (!mounted) return;

    final hasProfile = result.fold(
      (failure) => false,
      (profile) => profile != null,
    );

    if (hasProfile) {
      context.router.replaceAll([const TabBarRoute()]);
    } else {
      context.router.replaceAll([const OnboardingRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Center(
        child: CircularProgressIndicator(color: ColorManager.primary),
      ),
    );
  }
}
