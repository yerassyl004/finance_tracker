import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/domain/models/financial_profile.dart';
import 'package:finance_app/presentation/survey/bloc/survey_bloc.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A small curated set of common currencies offered in the survey.
const List<({String code, String label})> kSurveyCurrencies = [
  (code: 'USD', label: 'USD — US Dollar'),
  (code: 'EUR', label: 'EUR — Euro'),
  (code: 'GBP', label: 'GBP — British Pound'),
  (code: 'KZT', label: 'KZT — Kazakhstani Tenge'),
  (code: 'RUB', label: 'RUB — Russian Ruble'),
  (code: 'INR', label: 'INR — Indian Rupee'),
  (code: 'JPY', label: 'JPY — Japanese Yen'),
];

/// Step 0 — soft, non-numeric questions that personalise the app and give
/// us cohort data before we ask for sensitive amounts.
class SurveyProfileStep extends StatelessWidget {
  final SurveyData data;

  const SurveyProfileStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SurveyBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.surveyProfileTitle, style: AppTextStyle.bold20()),
        8.ph,
        Text(
          AppStrings.surveyProfileSubtitle,
          style: AppTextStyle.body14Medium().copyWith(color: ColorManager.grey),
        ),
        24.ph,
        Text(AppStrings.surveyGoalLabel, style: AppTextStyle.body15Medium()),
        12.ph,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: FinancialGoal.values.map((goal) {
            final selected = data.goal == goal;
            return ChoiceChip(
              label: Text(goal.label),
              selected: selected,
              onSelected: (_) => bloc.add(SurveyEvent.goalChanged(goal)),
              labelStyle: AppTextStyle.body14Medium().copyWith(
                color: selected ? ColorManager.white : ColorManager.black,
              ),
              selectedColor: ColorManager.primary,
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(
                  color: selected ? ColorManager.primary : Colors.transparent,
                ),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
        24.ph,
        Text(
          AppStrings.surveyCurrencyLabel,
          style: AppTextStyle.body15Medium(),
        ),
        8.ph,
        DropdownButtonFormField<String>(
          initialValue: data.currencyCode,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.currency_exchange,
              color: ColorManager.primary,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
          items: kSurveyCurrencies
              .map(
                (c) => DropdownMenuItem(
                  value: c.code,
                  child: Text(c.label, style: AppTextStyle.body14Medium()),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              bloc.add(SurveyEvent.currencyChanged(value));
            }
          },
        ),
        24.ph,
        Text(
          AppStrings.surveyPayFrequencyLabel,
          style: AppTextStyle.body15Medium(),
        ),
        12.ph,
        Row(
          children: PayFrequency.values.map((freq) {
            final selected = data.payFrequency == freq;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: freq == PayFrequency.values.last ? 0 : 8.w,
                ),
                child: OutlinedButton(
                  onPressed: () =>
                      bloc.add(SurveyEvent.payFrequencyChanged(freq)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(48.h),
                    backgroundColor: selected
                        ? ColorManager.primary
                        : Colors.transparent,
                    side: BorderSide(
                      color: selected
                          ? ColorManager.primary
                          : ColorManager.lightGrey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    freq.label,
                    style: AppTextStyle.body14Medium().copyWith(
                      color: selected ? ColorManager.white : ColorManager.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
