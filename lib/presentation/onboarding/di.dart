import 'package:finance_app/app/di.dart';
import 'package:finance_app/presentation/onboarding/bloc/onboarding_bloc.dart';

extension OnboardingDI on DI {
  OnboardingBloc getOnboardingBloc(int totalPages) {
    return OnboardingBloc(totalPages);
  }
}
