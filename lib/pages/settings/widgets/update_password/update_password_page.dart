// lib/pages/settings/widgets/update_password/update_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/settings/widgets/update_password/bloc/update_password_bloc.dart';
import 'package:wal/pages/settings/widgets/update_password/bloc/update_password_state.dart';
import 'package:wal/pages/settings/widgets/update_password/update_password_controller.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePasswordBloc(),
      child: Builder(
        builder: (blocContext) {
          return BlocListener<UpdatePasswordBloc, UpdatePasswordState>(
            listener: (context, state) {
              if (state.success && state.message.isNotEmpty) {
                // Success handled in controller with toast
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                });
              }
            },
            child: BlocBuilder<UpdatePasswordBloc, UpdatePasswordState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: AppColors.background,
                  body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18.sp,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      'Update Password',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Icon
                      Center(
                        child: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.lock_reset,
                            color: Colors.white,
                            size: 50.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Title
                      Text(
                        'Change Your Password',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Enter your current password and choose a new secure password',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Old Password Field
                      _buildPasswordField(
                        controller: _oldPasswordController,
                        label: 'Current Password',
                        hint: 'Enter your current password',
                        obscureText: _obscureOldPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureOldPassword = !_obscureOldPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      // New Password Field
                      _buildPasswordField(
                        controller: _newPasswordController,
                        label: 'New Password',
                        hint: 'Enter your new password',
                        obscureText: _obscureNewPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Confirm Password Field
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirm New Password',
                        hint: 'Re-enter your new password',
                        obscureText: _obscureConfirmPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),

                      // Password Requirements
                      _buildPasswordRequirements(),
                      SizedBox(height: 32.h),

                      // Update Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : () => _handleUpdatePassword(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: state.isLoading
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryText,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Update Password',
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(color: AppColors.primaryText, fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.secondaryText.withOpacity(0.5),
              fontSize: 16.sp,
            ),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: AppColors.muted.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 18.h,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.secondaryText,
                size: 22.sp,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    final newPassword = _newPasswordController.text;
    final hasMinLength = newPassword.length >= 6;
    final hasMatch =
        newPassword.isNotEmpty &&
        newPassword == _confirmPasswordController.text;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.muted.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          _buildRequirementItem(
            'At least 6 characters',
            hasMinLength || newPassword.isEmpty,
          ),
          SizedBox(height: 8.h),
          _buildRequirementItem(
            'Passwords match',
            hasMatch ||
                newPassword.isEmpty ||
                _confirmPasswordController.text.isEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isValid) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid
                ? AppColors.primaryColor.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
          ),
          child: Icon(
            isValid ? Icons.check : Icons.close,
            size: 14.sp,
            color: isValid ? AppColors.primaryColor : Colors.red,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isValid ? AppColors.primaryText : AppColors.secondaryText,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleUpdatePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;

    // Call controller to update password
    final controller = UpdatePasswordController(context: context);
    await controller.updatePassword(oldPassword, newPassword);
  }
}

