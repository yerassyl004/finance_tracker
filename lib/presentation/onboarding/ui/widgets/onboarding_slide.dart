import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/presentation/onboarding/ui/widgets/onboarding_content.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData slide;

  const OnboardingSlide({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              color: ColorManager.primaryOpacity70,
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 64.sp, color: ColorManager.white),
          ),
          40.ph,
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.bold24(),
          ),
          16.ph,
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: AppTextStyle.body16Regular().copyWith(
              color: ColorManager.grey,
            ),
          ),
        ],
      ),
    );
  }
}
