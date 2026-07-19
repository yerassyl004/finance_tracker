import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/app/di.dart';
import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/presentation/survey/bloc/survey_bloc.dart';
import 'package:finance_app/presentation/survey/di.dart';
import 'package:finance_app/presentation/survey/ui/widgets/survey_budget_step.dart';
import 'package:finance_app/presentation/survey/ui/widgets/survey_fixed_step.dart';
import 'package:finance_app/presentation/survey/ui/widgets/survey_income_step.dart';
import 'package:finance_app/presentation/survey/ui/widgets/survey_profile_step.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getSurveyBloc()..add(const SurveyEvent.started()),
      child: const SurveyView(),
    );
  }
}

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: BlocConsumer<SurveyBloc, SurveyState>(
          listenWhen: (_, current) => current is SurveySuccess,
          listener: (context, state) {
            // Survey complete → the profile now exists, so enter the app.
            context.router.replaceAll([const TabBarRoute()]);
          },
          builder: (context, state) {
            return state.maybeWhen(
              editing: (data) => _SurveyForm(data: data),
              submitting: (data) => _SurveyForm(data: data, isSubmitting: true),
              error: (message) => _SurveyMessage(message: message),
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}

class _SurveyForm extends StatelessWidget {
  final SurveyData data;
  final bool isSubmitting;

  const _SurveyForm({required this.data, this.isSubmitting = false});

  @override
  Widget build(BuildContext context) {
    final isLastStep = data.step == kSurveyStepCount - 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.surveyHeader, style: AppTextStyle.bold24()),
              12.ph,
              _StepProgress(currentStep: data.step),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
            child: _stepBody(data.step),
          ),
        ),
        if (data.errorMessage != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
            child: Text(
              data.errorMessage!,
              style: AppTextStyle.body14Medium().copyWith(
                color: ColorManager.error,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
          child: Row(
            children: [
              if (data.step > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => context.read<SurveyBloc>().add(
                            const SurveyEvent.previousStep(),
                          ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(52.h),
                      side: BorderSide(color: ColorManager.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      AppStrings.surveyBack,
                      style: AppTextStyle.bold16().copyWith(
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ),
              if (data.step > 0) 16.pw,
              Expanded(
                child: ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () => context.read<SurveyBloc>().add(
                          isLastStep
                              ? const SurveyEvent.submitted()
                              : const SurveyEvent.nextStep(),
                        ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(52.h),
                    backgroundColor: ColorManager.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorManager.white,
                          ),
                        )
                      : Text(
                          isLastStep
                              ? AppStrings.surveyFinish
                              : AppStrings.surveyNext,
                          style: AppTextStyle.bold16().copyWith(
                            color: ColorManager.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepBody(int step) {
    switch (step) {
      case 0:
        return SurveyProfileStep(data: data);
      case 1:
        return SurveyIncomeStep(data: data);
      case 2:
        return SurveyFixedStep(data: data);
      case 3:
      default:
        return SurveyBudgetStep(data: data);
    }
  }
}

class _StepProgress extends StatelessWidget {
  final int currentStep;

  const _StepProgress({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(kSurveyStepCount, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            height: 6.h,
            margin: EdgeInsets.only(
              right: index == kSurveyStepCount - 1 ? 0 : 6.w,
            ),
            decoration: BoxDecoration(
              color: isActive ? ColorManager.primary : ColorManager.lightGrey,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        );
      }),
    );
  }
}

class _SurveyMessage extends StatelessWidget {
  final String message;

  const _SurveyMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: ColorManager.error, size: 48.sp),
            16.ph,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.body16Medium(),
            ),
            24.ph,
            ElevatedButton(
              onPressed: () =>
                  context.read<SurveyBloc>().add(const SurveyEvent.started()),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
              ),
              child: Text(
                AppStrings.surveyRetry,
                style: AppTextStyle.bold16().copyWith(
                  color: ColorManager.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
