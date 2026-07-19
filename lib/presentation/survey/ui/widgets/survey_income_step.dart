import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/presentation/survey/bloc/survey_bloc.dart';
import 'package:finance_app/presentation/survey/ui/widgets/survey_amount_field.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurveyIncomeStep extends StatelessWidget {
  final SurveyData data;

  const SurveyIncomeStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SurveyBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.surveyIncomeTitle, style: AppTextStyle.bold20()),
        8.ph,
        Text(
          AppStrings.surveyIncomeSubtitle,
          style: AppTextStyle.body14Medium().copyWith(color: ColorManager.grey),
        ),
        24.ph,
        SurveyAmountField(
          label: AppStrings.surveySalary,
          icon: Icons.payments,
          hint: '0',
          initialValue: data.salary,
          onChanged: (value) =>
              bloc.add(SurveyEvent.fieldChanged(SurveyField.salary, value)),
        ),
        16.ph,
        SurveyAmountField(
          label: AppStrings.surveyOtherIncome,
          icon: Icons.attach_money,
          hint: '0',
          initialValue: data.otherIncome,
          onChanged: (value) => bloc.add(
            SurveyEvent.fieldChanged(SurveyField.otherIncome, value),
          ),
        ),
      ],
    );
  }
}
