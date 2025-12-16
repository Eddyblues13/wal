// lib/pages/wallet_creation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/home/dialog/create_new_wallet_page.dart';

class WalletCreationPage extends StatefulWidget {
  const WalletCreationPage({super.key});

  @override
  State<WalletCreationPage> createState() => _WalletCreationPageState();
}

class _WalletCreationPageState extends State<WalletCreationPage> {
  String _selectedOption = 'secret_phrase';

  @override
  Widget build(BuildContext context) {
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
                        'Add wallet',
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWalletOption(
                      value: 'secret_phrase',
                      title: 'Create new wallet',
                      subtitle: 'Secret phrase or FaceID / fingerprint',
                      isRecommended: true,
                    ),
                    SizedBox(height: 16.h),
                    _buildWalletOption(
                      value: 'existing_wallet',
                      title: 'Add existing wallet',
                      subtitle: 'Secret phrase, iCloud or view-only',
                    ),
                    SizedBox(height: 32.h),
                    _buildActionButton(
                      text: 'Continue',
                      onPressed: () {
                        if (_selectedOption == 'secret_phrase') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateNewWalletPage(),
                            ),
                          );
                        } else {
                          // Navigate to import existing wallet
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletOption({
    required String value,
    required String title,
    required String subtitle,
    bool isRecommended = false,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedOption = value),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _selectedOption == value
                ? AppColors.primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedOption == value
                      ? AppColors.primaryColor
                      : AppColors.secondaryText,
                  width: 2,
                ),
              ),
              child: _selectedOption == value
                  ? Icon(
                      Icons.circle,
                      size: 10.sp,
                      color: AppColors.primaryColor,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isRecommended) SizedBox(width: 8.w),
                      if (isRecommended)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
