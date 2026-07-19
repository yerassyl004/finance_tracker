import 'package:flutter/material.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';

/// A single onboarding slide describing one part of the app.
class OnboardingSlideData {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingSlideData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// The slides shown during onboarding, explaining the core app functions.
const List<OnboardingSlideData> onboardingSlides = [
  OnboardingSlideData(
    icon: Icons.account_balance_wallet,
    title: AppStrings.onboardingWelcomeTitle,
    description: AppStrings.onboardingWelcomeBody,
  ),
  OnboardingSlideData(
    icon: Icons.swap_horiz,
    title: AppStrings.onboardingTransactionsTitle,
    description: AppStrings.onboardingTransactionsBody,
  ),
  OnboardingSlideData(
    icon: Icons.category,
    title: AppStrings.onboardingCategoriesTitle,
    description: AppStrings.onboardingCategoriesBody,
  ),
  OnboardingSlideData(
    icon: Icons.analytics,
    title: AppStrings.onboardingAnalysisTitle,
    description: AppStrings.onboardingAnalysisBody,
  ),
];
