// sign_in.dart - UPDATED (only the changed parts)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart'; // ADD THIS IMPORT
import 'package:wal/common/routes/names.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_event.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_state.dart';
import 'package:wal/pages/sign_in/sign_in_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Container(
          color: AppColors.background,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: state.isLoading
                  ? const Center(
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
                              "https://assets10.lottiefiles.com/packages/lf20_jcikwtux.json",
                              height: 200.h,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.account_circle,
                                  size: 120.w,
                                  color: AppColors.primaryColor,
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Username Field
                          _buildTextFieldSection(
                            "Username",
                            Icons.person_outline,
                            _usernameController,
                            false,
                            (value) {
                              context.read<SignInBloc>().add(
                                UsernameEvent(value),
                              );
                            },
                          ),

                          // Password Field
                          _buildTextFieldSection(
                            "Password",
                            Icons.lock_outline,
                            _passwordController,
                            true,
                            (value) {
                              context.read<SignInBloc>().add(
                                PasswordEvent(value),
                              );
                            },
                          ),

                          // Forgot Password
                          _buildForgotPassword(),

                          // Sign In Button
                          _buildActionButton(
                            "Sign In",
                            AppColors.primaryColor,
                            () {
                              SignInController(
                                context: context,
                              ).handleSignIn("email");
                            },
                          ),

                          // Divider
                          _buildDivider(),

                          // Sign Up Button - UPDATED
                          _buildActionButton(
                            "Create New Account",
                            AppColors.purpleBadge,
                            _navigateToSignUp, // CHANGED: Use the new method
                          ),

                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  // Add the _navigateToSignUp method
  void _navigateToSignUp() {
    final url = "https://starmallinternational.com/shop/app/register.php";
    _launchURL(url);
  }

  // Add the _launchURL method (same as in welcome.dart)
  void _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Keep all other UI methods the same (_buildAppBar, _buildTextFieldSection, etc.)
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Row(
        children: [
          Text(
            "Sign In",
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldSection(
    String label,
    IconData icon,
    TextEditingController controller,
    bool isPassword,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
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
              controller: controller,
              style: TextStyle(color: AppColors.primaryText, fontSize: 16.sp),
              obscureText: isPassword && _obscurePassword,
              onChanged: onChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: AppColors.secondaryText),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.secondaryText,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      )
                    : null,
                hintText: "Enter your $label",
                hintStyle: TextStyle(color: AppColors.muted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(right: 25.w, top: 10.h, bottom: 20.h),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.FORGOT_PASSWORD);
        },
        child: Text(
          "Forgot Password?",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 2,
            shadowColor: color.withOpacity(0.3),
          ),
          child: Text(
            text,
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

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.muted, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              "OR",
              style: TextStyle(color: AppColors.secondaryText, fontSize: 14.sp),
            ),
          ),
          Expanded(child: Divider(color: AppColors.muted, thickness: 1)),
        ],
      ),
    );
  }
}
