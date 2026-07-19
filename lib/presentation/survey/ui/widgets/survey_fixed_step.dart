import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/presentation/survey/bloc/survey_bloc.dart';
import 'package:finance_app/presentation/survey/ui/widgets/survey_amount_field.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurveyFixedStep extends StatelessWidget {
  final SurveyData data;

  const SurveyFixedStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SurveyBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.surveyFixedTitle, style: AppTextStyle.bold20()),
        8.ph,
        Text(
          AppStrings.surveyFixedSubtitle,
          style: AppTextStyle.body14Medium().copyWith(color: ColorManager.grey),
        ),
        24.ph,
        SurveyAmountField(
          label: AppStrings.surveyHouse,
          icon: Icons.home,
          hint: '0',
          initialValue: data.housePayment,
          onChanged: (value) => bloc.add(
            SurveyEvent.fieldChanged(SurveyField.housePayment, value),
          ),
        ),
        16.ph,
        SurveyAmountField(
          label: AppStrings.surveyCar,
          icon: Icons.directions_car,
          hint: '0',
          initialValue: data.carPayment,
          onChanged: (value) =>
              bloc.add(SurveyEvent.fieldChanged(SurveyField.carPayment, value)),
        ),
        16.ph,
        SurveyAmountField(
          label: AppStrings.surveyUtilities,
          icon: Icons.bolt,
          hint: '0',
          initialValue: data.utilitiesPayment,
          onChanged: (value) => bloc.add(
            SurveyEvent.fieldChanged(SurveyField.utilitiesPayment, value),
          ),
        ),
      ],
    );
  }
}
