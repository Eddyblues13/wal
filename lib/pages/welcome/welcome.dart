import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wal/common/routes/names.dart';

import 'bloc/welcome_blocs.dart';
import 'bloc/welcome_events.dart';
import 'bloc/welcome_states.dart';
import '../../common/values/colors.dart';
import '../../common/values/constant.dart';
import '../../global.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<WelcomeBloc, WelcomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    context.read<WelcomeBloc>().add(WelcomeEvent(page: index));
                  },
                  children: [
                    _page(
                      index: 0,
                      title: "Welcome to WAL",
                      subTitle:
                          "Your secure digital wallet to store, send and grow your assets — all in one place.",
                      animationUrl:
                          "https://assets8.lottiefiles.com/packages/lf20_h4th9ofg.json",
                      primaryText: "Next",
                    ),
                    _page(
                      index: 1,
                      title: "Secure & Private",
                      subTitle:
                          "Only you control your funds. WAL never has access to your private keys.",
                      animationUrl:
                          "https://assets1.lottiefiles.com/packages/lf20_2glqweqs.json",
                      primaryText: "Next",
                    ),
                    _page(
                      index: 2,
                      title: "Start Your Journey",
                      subTitle: "Create a free account or sign in to continue.",
                      animationUrl:
                          "https://assets8.lottiefiles.com/packages/lf20_h4th9ofg.json",
                      primaryText: "Sign Up",
                      isLastPage: true,
                    ),
                  ],
                ),
                // Show dots only on non-final pages
                if (state.page < 2)
                  Positioned(
                    bottom: 90.h,
                    child: DotsIndicator(
                      position: state.page.toDouble(),
                      dotsCount: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      decorator: DotsDecorator(
                        color: AppColors.muted,
                        activeColor: AppColors.primaryColor,
                        size: const Size.square(8.0),
                        activeSize: const Size(18.0, 8.0),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _page({
    required int index,
    required String title,
    required String subTitle,
    required String animationUrl,
    required String primaryText,
    bool isLastPage = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          SizedBox(height: 60.h),
          // Animation
          SizedBox(
            width: 250.w,
            height: 250.w,
            child: Lottie.network(
              animationUrl,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.error, color: AppColors.primaryColor, size: 50.w),
            ),
          ),
          SizedBox(height: 30.h),
          // Title
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          // Subtitle
          Text(
            subTitle,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 15.sp,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // If it's the last page, show Sign Up + Sign In cleanly
          if (isLastPage) ...[
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _navigateToSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.w),
                  ),
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: OutlinedButton(
                onPressed: _navigateToSignIn,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.w),
                  ),
                ),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ] else
            // Non-final pages show "Next"
            GestureDetector(
              onTap: () {
                pageController.animateToPage(
                  index + 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(25.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    primaryText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    try {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open the URL: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToSignIn() {
    Global.storageService.setBool(
      AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME,
      true,
    );
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.SIGN_IN, (route) => false);
  }

  void _navigateToSignUp() {
    Global.storageService.setBool(
      AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME,
      true,
    );

    final url = "https://starmallinternational.com/shop/app/register.php";
    _launchURL(url);
  }

  // void _navigateToSignUp() {
  //   Global.storageService.setBool(
  //     AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME,
  //     true,
  //   );
  //   Navigator.of(
  //     context,
  //   ).pushNamedAndRemoveUntil(AppRoutes.SIGN_UP, (route) => false);
  // }
}
