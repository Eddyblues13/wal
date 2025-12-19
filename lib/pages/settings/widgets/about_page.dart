// lib/pages/settings/widgets/about_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/settings/bloc/settings_bloc.dart';
import 'package:wal/pages/settings/bloc/settings_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
                        'About',
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
                padding: EdgeInsets.all(16.w),
                children: [
                  // App Icon and Version
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 40.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Star Wallet',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // About Info
                  _AboutInfoTile(
                    label: 'Website',
                    value: 'starwallet.com',
                    onTap: () => _openWebsite(context),
                  ),
                  _dividerLine(),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          _AboutInfoTile(
                            label: 'Privacy Policy',
                            value: '',
                            onTap: () => _openPrivacyPolicy(
                              context,
                              state.privacyPolicyUrl,
                            ),
                          ),
                          _dividerLine(),
                          _AboutInfoTile(
                            label: 'Terms of Service',
                            value: '',
                            onTap: () => _openTermsOfService(
                              context,
                              state.termsOfServiceUrl,
                            ),
                          ),
                          _dividerLine(),
                          _AboutInfoTile(
                            label: 'Open Source Licenses',
                            value: '',
                            onTap: () => _showOpenSourceLicenses(
                              context,
                              state.openSourceLicensesUrl,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 32.h),

                  // Team Info
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Star Wallet is the most trusted and secure crypto wallet. '
                      'Buy, store, collect NFTs, exchange & earn crypto. '
                      'Join millions of people using Star Wallet.',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

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

  Future<void> _openWebsite(BuildContext context) async {
    try {
      final url = Uri.parse('https://starwallet.com');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch website'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openPrivacyPolicy(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url.isNotEmpty ? url : 'https://starwallet.com/privacy-policy');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch Privacy Policy'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openTermsOfService(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url.isNotEmpty ? url : 'https://starwallet.com/terms-of-service');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch Terms of Service'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOpenSourceLicenses(BuildContext context, String url) {
    if (url.isNotEmpty) {
      // If URL is provided, open it
      _openUrl(context, url);
    } else {
      // Fallback to license page
      showLicensePage(
        context: context,
        applicationName: 'Star Wallet',
        applicationVersion: '1.0.0',
      );
    }
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch URL'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _AboutInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _AboutInfoTile({
    required this.label,
    required this.value,
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
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (value.isNotEmpty)
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14.sp,
                  ),
                ),
              SizedBox(width: 8.w),
              Icon(Icons.chevron_right, color: AppColors.primaryText, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}

