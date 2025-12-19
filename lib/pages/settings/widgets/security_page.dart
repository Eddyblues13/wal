// lib/pages/settings/widgets/security_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/settings/widgets/update_password/update_password_page.dart';
import 'package:wal/pages/settings/widgets/recovery_phrase_page.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              child: Row(
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: AppColors.background,
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

                  // Title centered visually
                  Expanded(
                    child: Center(
                      child: Text(
                        'Security',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Placeholder for symmetry
                  SizedBox(width: 36.w),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 6.h),

                  // Recovery Phrase
                  _SecurityTile(
                    icon: Icons.security,
                    label: 'Recovery Phrase',
                    description: 'Back up your wallet',
                    onTap: () => _showRecoveryPhraseDialog(context),
                  ),
                  _dividerLine(),

                  // Update Password
                  _SecurityTile(
                    icon: Icons.lock,
                    label: 'Update Password',
                    description: 'Change your account password',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdatePasswordPage(),
                      ),
                    ),
                  ),
                  _dividerLine(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dividerLine() {
    return Container(
      height: 1.h,
      color: AppColors.divider,
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
    );
  }

  void _showRecoveryPhraseDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecoveryPhrasePage(),
      ),
    );
  }

}

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _SecurityTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryText, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.primaryText, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}

