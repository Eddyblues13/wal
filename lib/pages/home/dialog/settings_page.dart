// lib/pages/home/dialog/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/home/bloc/home_bloc.dart';
import 'package:wal/pages/home/bloc/home_event.dart';
import 'package:wal/pages/home/bloc/home_state.dart';
import 'package:wal/pages/home/dialog/preferences_page.dart';
import 'package:wal/pages/home/dialog/security_page.dart';
import 'package:wal/pages/home/dialog/about_page.dart';
import 'package:wal/pages/home/dialog/profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header: back arrow + centered title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryText,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      // Title centered
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      // Placeholder for symmetry
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 6),

                      // Profile Section
                      if (state.userProfile != null) ...[
                        _ProfileSection(
                          userProfile: state.userProfile!,
                          referralCode: state.referralCode,
                          isReferralCodeCopied: state.isReferralCodeCopied,
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, color: AppColors.divider),
                        const SizedBox(height: 12),
                      ],

                      // Preferences
                      _SettingsTile(
                        icon: const Icon(
                          Icons.settings_outlined,
                          color: AppColors.primaryText,
                          size: 22,
                        ),
                        label: 'Preferences',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PreferencesPage(),
                          ),
                        ),
                      ),
                      _dividerLine(),

                      // Security
                      _SettingsTile(
                        icon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryText,
                          size: 22,
                        ),
                        label: 'Security',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SecurityPage(),
                          ),
                        ),
                      ),
                      _dividerLine(),

                      // About
                      _SettingsTile(
                        icon: const Icon(
                          Icons.shield_outlined,
                          color: AppColors.primaryText,
                          size: 22,
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
                      const SizedBox(height: 16),
                      Container(height: 1, color: AppColors.divider),
                      const SizedBox(height: 12),

                      // Social links
                      _SettingsTile(
                        leadingWidget: _socialCircle(text: 'X'),
                        label: 'X (formerly Twitter)',
                        onTap: () => _openSocialLink(
                          context,
                          'https://twitter.com/trustwallet',
                        ),
                      ),
                      _dividerLine(),
                      _SettingsTile(
                        leadingWidget: _socialCircle(icon: Icons.send),
                        label: 'Telegram',
                        onTap: () => _openSocialLink(
                          context,
                          'https://t.me/trustwallet',
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Divider line
  static Widget _dividerLine() {
    return Container(
      height: 1,
      color: AppColors.divider,
      margin: const EdgeInsets.only(left: 68),
    );
  }

  // Social media icon container
  static Widget _socialCircle({String? text, IconData? icon}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: text != null
            ? Text(
                text,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Icon(icon, color: AppColors.primaryText, size: 18),
      ),
    );
  }

  // Open social links
  static void _openSocialLink(BuildContext context, String url) {
    // In a real app, you would use url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening: $url'),
        backgroundColor: AppColors.primaryColor,
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile['name'] ?? 'User',
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userProfile['email'] ?? '',
                          style: TextStyle(
                            color: AppColors.primaryText.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userProfile['level'] ?? 'Member',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.primaryText),
                ],
              ),
              const SizedBox(height: 20),

              // Referral Code Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Referral Code',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Text(
                              referralCode,
                              style: const TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            context.read<HomeBloc>().add(
                              const HomeCopyReferralCode(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isReferralCodeCopied
                                      ? 'Referral code copied!'
                                      : 'Copying referral code...',
                                ),
                                backgroundColor: AppColors.primaryColor,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.copy,
                              color: AppColors.primaryText,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Share this code with friends and earn rewards!',
                      style: TextStyle(
                        color: AppColors.primaryText.withOpacity(0.6),
                        fontSize: 12,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              leadingWidget ??
                  (icon ??
                      const Icon(
                        Icons.circle,
                        color: AppColors.primaryText,
                        size: 20,
                      )),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primaryText),
            ],
          ),
        ),
      ),
    );
  }
}
