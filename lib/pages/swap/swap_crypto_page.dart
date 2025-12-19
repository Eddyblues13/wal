// lib/pages/swap/swap_crypto_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/swap/bloc/swap_bloc.dart';
import 'package:wal/pages/swap/bloc/swap_state.dart';
import 'package:wal/pages/swap/swap_controller.dart';
import 'package:wal/pages/swap/swap.dart';

class SwapCryptoPage extends StatefulWidget {
  const SwapCryptoPage({super.key});

  @override
  State<SwapCryptoPage> createState() => _SwapCryptoPageState();
}

class _SwapCryptoPageState extends State<SwapCryptoPage> {
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SwapBloc(),
      child: Builder(
        builder: (blocContext) {
          // Load swap data once when bloc is available
          if (!_hasInitialized) {
            _hasInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                SwapController(context: blocContext).loadSwapData();
              }
            });
          }
          
          return BlocBuilder<SwapBloc, SwapState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 36.w,
                                height: 36.h,
                                decoration: BoxDecoration(
                                  color: AppColors.iconBackground,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 18.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Swap',
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 36.w),
                          ],
                        ),
                      ),
                      // Content
                      Expanded(
                        child: state.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColor,
                                  ),
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.swap_horiz,
                                      size: 64.sp,
                                      color: AppColors.muted,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      "Swap Crypto",
                                      style: TextStyle(
                                        color: AppColors.primaryText,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "Exchange your crypto assets instantly",
                                      style: TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 14.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 24.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56.h,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Navigate to main swap page
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const SwapPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(28.r),
                                            ),
                                          ),
                                          child: Text(
                                            'Start Swapping',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

