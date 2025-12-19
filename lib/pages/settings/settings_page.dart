// lib/pages/settings/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/application/bloc/app_blocs.dart';
import 'package:wal/pages/application/bloc/app_events.dart';
import 'package:wal/pages/settings/bloc/settings_bloc.dart';
import 'package:wal/pages/settings/bloc/settings_event.dart';
import 'package:wal/pages/settings/bloc/settings_state.dart';
import 'package:wal/pages/settings/settings_controller.dart';
import 'package:wal/pages/settings/widgets/security_page.dart';
import 'package:wal/pages/settings/widgets/about_page.dart';
import 'package:wal/pages/settings/widgets/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(),
      child: Builder(
        builder: (blocContext) {
          // Load settings data once when bloc is available
          if (!_hasInitialized) {
            _hasInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                SettingsController(context: blocContext).loadSettingsData();
              }
            });
          }

          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: SafeArea(
                  child: Column(
                    children: [
                      // Header: back arrow + centered title
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            // Back button
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppColors.primaryText,
                                size: 24.sp,
                              ),
                              onPressed: () {
                                final navigator = Navigator.of(context);
                                if (navigator.canPop()) {
                                  navigator.pop();
                                } else {
                                  // When opened from bottom nav (no back stack), go to Home tab
                                  blocContext.read<AppBlocs>().add(
                                    const TriggerAppEvent(0),
                                  );
                                }
                              },
                            ),
                            // Title centered
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Settings',
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            // Placeholder for symmetry
                            SizedBox(width: 48.w),
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
                            : ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  SizedBox(height: 6.h),

                                  // Profile Section
                                  if (state.userProfile != null) ...[
                                    _ProfileSection(
                                      userProfile: state.userProfile!,
                                      referralCode: state.referralCode,
                                      isReferralCodeCopied:
                                          state.isReferralCodeCopied,
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      height: 1.h,
                                      color: AppColors.divider,
                                    ),
                                    SizedBox(height: 12.h),
                                  ],

                                  // Security
                                  _SettingsTile(
                                    icon: Icon(
                                      Icons.lock_outline,
                                      color: AppColors.primaryText,
                                      size: 22.sp,
                                    ),
                                    label: 'Security',
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SecurityPage(),
                                      ),
                                    ),
                                  ),
                                  _dividerLine(),

                                  // About
                                  _SettingsTile(
                                    icon: Icon(
                                      Icons.shield_outlined,
                                      color: AppColors.primaryText,
                                      size: 22.sp,
                                    ),
                                    label: 'About',
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AboutPage(),
                                      ),
                                    ),
                                  ),

                                  // Separator
                                  SizedBox(height: 16.h),
                                  Container(
                                    height: 1.h,
                                    color: AppColors.divider,
                                  ),
                                  SizedBox(height: 12.h),

                                  // Social links
                                  _SettingsTile(
                                    leadingWidget: _socialCircle(text: 'X'),
                                    label: 'X (formerly Twitter)',
                                    onTap: () => _openSocialLink(
                                      context,
                                      state.xLink.isNotEmpty
                                          ? state.xLink
                                          : 'https://twitter.com/starwallet',
                                    ),
                                  ),
                                  _dividerLine(),
                                  _SettingsTile(
                                    leadingWidget: _socialCircle(
                                      icon: Icons.send,
                                    ),
                                    label: 'Telegram',
                                    onTap: () => _openSocialLink(
                                      context,
                                      state.telegramLink.isNotEmpty
                                          ? state.telegramLink
                                          : 'https://t.me/starwallet',
                                    ),
                                  ),

                                  // Separator
                                  SizedBox(height: 16.h),
                                  Container(
                                    height: 1.h,
                                    color: AppColors.divider,
                                  ),
                                  SizedBox(height: 12.h),

                                  // Logout Button
                                  _LogoutTile(
                                    onTap: () => _showLogoutDialog(context),
                                  ),

                                  SizedBox(height: 20.h),
                                ],
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

  // Divider line
  Widget _dividerLine() {
    return Container(
      height: 1.h,
      color: AppColors.divider,
      margin: EdgeInsets.only(left: 68.w),
    );
  }

  // Social media icon container
  Widget _socialCircle({String? text, IconData? icon}) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: text != null
            ? Text(
                text,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              )
            : Icon(icon, color: AppColors.primaryText, size: 18.sp),
      ),
    );
  }

  // Open social links
  Future<void> _openSocialLink(BuildContext context, String url) async {
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

  // Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16.sp),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: AppColors.card,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 16.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                SettingsController(context: context).logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Profile Section Widget
class _ProfileSection extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final String referralCode;
  final bool isReferralCodeCopied;

  const _ProfileSection({
    required this.userProfile,
    required this.referralCode,
    required this.isReferralCodeCopied,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryColor,
                      size: 30.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile['name'] ?? 'User',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          userProfile['email'] ?? '',
                          style: TextStyle(
                            color: AppColors.primaryText.withOpacity(0.7),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Referral Code Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Referral Code',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Text(
                              referralCode,
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        InkWell(
                          onTap: () {
                            context.read<SettingsBloc>().add(
                              const CopyReferralCodeEvent(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isReferralCodeCopied
                                      ? 'Referral code copied!'
                                      : 'Copying referral code...',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: AppColors.primaryColor,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.copy,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Share this code with friends and earn rewards!',
                      style: TextStyle(
                        color: AppColors.primaryText.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single settings tile (icon left, label center, chevron right)
class _SettingsTile extends StatelessWidget {
  final Widget? leadingWidget;
  final Widget? icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    this.leadingWidget,
    this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              leadingWidget ??
                  (icon ??
                      Icon(
                        Icons.circle,
                        color: AppColors.primaryText,
                        size: 20.sp,
                      )),
              SizedBox(width: 16.w),
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
              Icon(
                Icons.chevron_right,
                color: AppColors.primaryText,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logout tile with red styling
class _LogoutTile extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 22.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.red, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}
