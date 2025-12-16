import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_bloc.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_event.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_state.dart';
import 'package:wal/pages/sign_up/sign_up_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          children: [
                            // App Bar
                            _buildAppBar(),

                            SizedBox(height: 10.h),

                            // Lottie Animation
                            Center(
                              child: Lottie.network(
                                "https://assets2.lottiefiles.com/packages/lf20_q5pk6p1k.json",
                                height: 150.h,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person_add_alt_1,
                                    size: 100.w,
                                    color: AppColors.primaryColor,
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Title
                            Text(
                              "Create Account",
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            // Subtitle
                            Text(
                              "Sign up to start your crypto journey",
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 30.h),

                            // First Name Field
                            _buildTextField(
                              "First Name",
                              Icons.person_outline,
                              _firstNameController,
                              TextInputType.name,
                              false,
                              (value) {
                                context.read<SignUpBloc>().add(
                                  FirstNameEvent(value),
                                );
                              },
                            ),

                            SizedBox(height: 15.h),

                            // Last Name Field
                            _buildTextField(
                              "Last Name",
                              Icons.person_outline,
                              _lastNameController,
                              TextInputType.name,
                              false,
                              (value) {
                                context.read<SignUpBloc>().add(
                                  LastNameEvent(value),
                                );
                              },
                            ),

                            SizedBox(height: 15.h),

                            // Email Field
                            _buildTextField(
                              "Email Address",
                              Icons.email_outlined,
                              _emailController,
                              TextInputType.emailAddress,
                              false,
                              (value) {
                                context.read<SignUpBloc>().add(
                                  EmailEvent(value),
                                );
                              },
                            ),

                            SizedBox(height: 15.h),

                            // Password Field
                            _buildPasswordField(
                              "Password",
                              _passwordController,
                              _obscurePassword,
                              (value) {
                                context.read<SignUpBloc>().add(
                                  PasswordEvent(value),
                                );
                              },
                              () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),

                            SizedBox(height: 15.h),

                            // Confirm Password Field
                            _buildPasswordField(
                              "Confirm Password",
                              _confirmPasswordController,
                              _obscureConfirmPassword,
                              (value) {
                                context.read<SignUpBloc>().add(
                                  ConfirmPasswordEvent(value),
                                );
                              },
                              () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),

                            SizedBox(height: 10.h),

                            // Password Match Indicator
                            if (state.password.isNotEmpty &&
                                state.confirmPassword.isNotEmpty)
                              _buildPasswordMatchIndicator(state),

                            SizedBox(height: 30.h),

                            // Sign Up Button
                            _buildSignUpButton(state),

                            SizedBox(height: 20.h),

                            // Already have account
                            _buildLoginLink(),

                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.secondaryText,
            size: 22.w,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          "Sign Up",
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller,
    TextInputType keyboardType,
    bool isPassword,
    Function(String) onChanged,
  ) {
    return Column(
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
            keyboardType: keyboardType,
            obscureText: isPassword,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.secondaryText),
              hintText: "Enter your $label",
              hintStyle: TextStyle(color: AppColors.muted),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    Function(String) onChanged,
    VoidCallback onToggleVisibility,
  ) {
    return Column(
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
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_outline,
                color: AppColors.secondaryText,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.secondaryText,
                ),
                onPressed: onToggleVisibility,
              ),
              hintText: "Enter your $label",
              hintStyle: TextStyle(color: AppColors.muted),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordMatchIndicator(SignUpState state) {
    final bool passwordsMatch = state.password == state.confirmPassword;
    final bool bothFilled =
        state.password.isNotEmpty && state.confirmPassword.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Icon(
            bothFilled
                ? (passwordsMatch ? Icons.check_circle : Icons.error)
                : Icons.circle,
            color: bothFilled
                ? (passwordsMatch ? AppColors.primaryColor : Colors.redAccent)
                : AppColors.muted,
            size: 16.w,
          ),
          SizedBox(width: 8.w),
          Text(
            bothFilled
                ? (passwordsMatch
                      ? "Passwords match"
                      : "Passwords do not match")
                : "Passwords must match",
            style: TextStyle(
              color: bothFilled
                  ? (passwordsMatch ? AppColors.primaryColor : Colors.redAccent)
                  : AppColors.secondaryText,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(SignUpState state) {
    final bool isFormValid =
        state.firstName.isNotEmpty &&
        state.lastName.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.confirmPassword.isNotEmpty &&
        state.password == state.confirmPassword;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: isFormValid
            ? () {
                SignUpController(context: context).handleSignUp();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? AppColors.primaryColor
              : AppColors.muted,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: isFormValid ? 4 : 0,
          shadowColor: isFormValid
              ? AppColors.primaryColor.withOpacity(0.4)
              : Colors.transparent,
        ),
        child: Text(
          "Create Account",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: AppColors.secondaryText, fontSize: 14.sp),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.SIGN_IN);
          },
          child: Text(
            "Sign In",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
