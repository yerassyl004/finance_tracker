import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/domain/models/category.dart';
import 'package:finance_app/presentation/survey/bloc/survey_bloc.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyBudgetStep extends StatelessWidget {
  final SurveyData data;

  const SurveyBudgetStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.surveyBudgetTitle, style: AppTextStyle.bold20()),
        8.ph,
        Text(
          AppStrings.surveyBudgetSubtitle,
          style: AppTextStyle.body14Medium().copyWith(color: ColorManager.grey),
        ),
        24.ph,
        ...data.expenseCategories.map(
          (category) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _BudgetRow(
              category: category,
              value: data.categoryBudgets[category.id] ?? '',
            ),
          ),
        ),
      ],
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final Category category;
  final String value;

  const _BudgetRow({required this.category, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/${category.icon}.png',
          width: 36.w,
          height: 36.w,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.category, color: ColorManager.primary, size: 36.w),
        ),
        12.pw,
        Expanded(
          child: Text(category.title, style: AppTextStyle.body16Medium()),
        ),
        SizedBox(
          width: 120.w,
          child: TextFormField(
            initialValue: value,
            textAlign: TextAlign.end,
            onChanged: (v) => context.read<SurveyBloc>().add(
              SurveyEvent.budgetChanged(category.id, v),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: InputDecoration(
              hintText: '0',
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
