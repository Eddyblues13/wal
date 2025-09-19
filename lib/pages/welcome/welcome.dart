import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<WelcomeBloc, WelcomeState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.only(top: 34.h),
            width: 375.w,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    state.page = index;
                    BlocProvider.of<WelcomeBloc>(context).add(WelcomeEvent());
                  },
                  children: [
                    _page(
                      1,
                      context,
                      "Enable Notifications",
                      "Keep up with the market!",
                      "Turn on notifications to keep track of prices and receive transaction updates.",
                      "assets/images/notification_illustration.png",
                      buttonColor: Colors.greenAccent.shade400,
                      showSecondaryButton: true,
                      secondaryButtonText: "Skip, I'll do it later",
                      onSecondaryButtonTap: () {
                        // Skip action
                        // Implement navigation or logic here
                      },
                    ),
                    _page(
                      2,
                      context,
                      "Create new wallet",
                      "Unlock opportunities across 100+ chains",
                      "By tapping any button you agree and consent to our Terms of Service and Privacy Policy.",
                      "assets/images/wallet_illustration.png",
                      buttonColor: Colors.greenAccent.shade400,
                      showSecondaryButton: true,
                      secondaryButtonText: "I already have a wallet",
                      onSecondaryButtonTap: () {
                        // Already have wallet action
                        // Implement navigation or logic here
                      },
                    ),
                    _page(
                      3,
                      context,
                      "Fund your wallet",
                      "Brilliant, your wallet is ready!",
                      "Add funds to get started",
                      "assets/images/wallet_ready_illustration.png",
                      buttonColor: Colors.greenAccent.shade400,
                      showSecondaryButton: true,
                      secondaryButtonText: "Skip",
                      onSecondaryButtonTap: () {
                        // Skip funding action
                        // Implement navigation or logic here
                      },
                    ),
                  ],
                ),
                Positioned(
                  bottom: 100.h,
                  child: DotsIndicator(
                    position: state.page.toDouble(),
                    dotsCount: 3,
                    mainAxisAlignment: MainAxisAlignment.center,
                    decorator: DotsDecorator(
                      color: Colors.grey.shade700,
                      activeColor: Colors.greenAccent.shade400,
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

  Widget _page(
    int index,
    BuildContext context,
    String buttonName,
    String title,
    String subTitle,
    String imagePath, {
    Color buttonColor = Colors.green,
    bool showSecondaryButton = false,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        children: [
          SizedBox(height: 80.h),
          SizedBox(
            width: 250.w,
            height: 250.w,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            subTitle,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (showSecondaryButton && secondaryButtonText != null)
            TextButton(
              onPressed: onSecondaryButtonTap,
              child: Text(
                secondaryButtonText,
                style: TextStyle(
                  color: Colors.greenAccent.shade400,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              if (index < 3) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              } else {
                // Last page action, e.g., navigate to home or sign in
                Global.storageService.setBool(
                    AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME, true);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/sign_in", (route) => false);
              }
            },
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.all(Radius.circular(25.w)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.shade400.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  buttonName,
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
}