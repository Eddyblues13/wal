// lib/pages/settings/widgets/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/settings/bloc/settings_bloc.dart';
import 'package:wal/pages/settings/bloc/settings_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryText, size: 24.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final userProfile = state.userProfile;
          
          if (userProfile == null) {
            return Center(
              child: Text(
                'No profile data available',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 16.sp),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 50.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        userProfile['name'] ?? 'User',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        userProfile['email'] ?? '',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Profile Details
                _ProfileDetailTile(
                  label: 'Name',
                  value: userProfile['name'] ?? 'User',
                ),
                _dividerLine(),
                _ProfileDetailTile(
                  label: 'Email',
                  value: userProfile['email'] ?? '',
                ),
                if (userProfile['joinDate'] != null) ...[
                  _dividerLine(),
                  _dividerLine(),
                  _ProfileDetailTile(
                    label: 'Join Date',
                    value: userProfile['joinDate'] ?? '',
                  ),
                ],
                if (userProfile['wallet'] != null) ...[
                  _dividerLine(),
                  _ProfileDetailTile(
                    label: 'Wallet Address',
                    value: userProfile['wallet'] ?? '',
                    isWallet: true,
                  ),
                ],

                SizedBox(height: 32.h),
              ],
            ),
          );
        },
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
}

class _ProfileDetailTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isWallet;

  const _ProfileDetailTile({
    required this.label,
    required this.value,
    this.isWallet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              isWallet && value.length > 20
                  ? '${value.substring(0, 10)}...${value.substring(value.length - 10)}'
                  : value,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

