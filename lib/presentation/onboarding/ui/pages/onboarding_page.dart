import 'package:auto_route/auto_route.dart';
import 'package:finance_app/app/di.dart';
import 'package:finance_app/app/extensions.dart';
import 'package:finance_app/app/app_router.dart';
import 'package:finance_app/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:finance_app/presentation/onboarding/di.dart';
import 'package:finance_app/presentation/onboarding/ui/widgets/onboarding_content.dart';
import 'package:finance_app/presentation/onboarding/ui/widgets/onboarding_slide.dart';
import 'package:finance_app/presentation/resourses/color_manager.dart';
import 'package:finance_app/presentation/resourses/strings_manager.dart';
import 'package:finance_app/presentation/resourses/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getOnboardingBloc(onboardingSlides.length),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next(OnboardingState state) {
    final isLast = state.currentPage == state.totalPages - 1;
    if (isLast) {
      // Required flow: onboarding leads straight into the survey. Replace so
      // the back gesture can't return to onboarding.
      context.router.replace(const SurveyRoute());
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            final isLast = state.currentPage == state.totalPages - 1;
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingSlides.length,
                    onPageChanged: (index) => context
                        .read<OnboardingBloc>()
                        .add(OnboardingEvent.pageChanged(index)),
                    itemBuilder: (_, index) =>
                        OnboardingSlide(slide: onboardingSlides[index]),
                  ),
                ),
                _PageIndicator(
                  count: state.totalPages,
                  currentIndex: state.currentPage,
                ),
                32.ph,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () => _next(state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        isLast
                            ? AppStrings.onboardingGetStarted
                            : AppStrings.onboardingNext,
                        style: AppTextStyle.bold16().copyWith(
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ),
                ),
                24.ph,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 24.w : 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isActive ? ColorManager.primary : ColorManager.lightGrey,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
