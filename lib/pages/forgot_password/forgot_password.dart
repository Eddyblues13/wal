import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_event.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_state.dart';
import 'package:wal/pages/forgot_password/forgot_password_controller.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return Container(
          color: AppColors.background,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Bar
                          _buildAppBar(),

                          // Lottie Animation
                          Center(
                            child: Lottie.network(
                              "https://assets1.lottiefiles.com/packages/lf20_kcsr6fcp.json",
                              height: 200.h,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.lock_reset,
                                  size: 120.w,
                                  color: AppColors.primaryColor,
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 10.h),

                          // Title
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Text(
                              "Reset Your Password",
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 10.h),

                          // Description
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Text(
                              "Enter your email address and we'll send you a link to reset your password",
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 30.h),

                          // Email Field
                          _buildEmailField(state),

                          SizedBox(height: 20.h),

                          // Reset Password Button
                          _buildResetPasswordButton(),

                          SizedBox(height: 20.h),

                          // Back to Sign In
                          _buildBackToSignIn(),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.secondaryText,
              size: 20.w,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "Forgot Password",
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(ForgotPasswordState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address",
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.muted.withOpacity(0.3)),
            ),
            child: TextField(
              controller: _emailController,
              style: TextStyle(color: AppColors.primaryText, fontSize: 16.sp),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordEmailEvent(value),
                );
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.secondaryText,
                ),
                hintText: "Enter your email address",
                hintStyle: TextStyle(color: AppColors.muted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
          if (state.error.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              state.error,
              style: TextStyle(color: Colors.redAccent, fontSize: 12.sp),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: () {
            ForgotPasswordController(context: context).handleForgotPassword();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 2,
            shadowColor: AppColors.primaryColor.withOpacity(0.3),
          ),
          child: Text(
            "Send Reset Link",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignIn() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Back to Sign In",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
