import 'package:flutter/material.dart';
import 'package:wal/common/values/colors.dart';

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
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),

                  // Title centered visually
                  const Expanded(
                    child: Center(
                      child: Text(
                        'About',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Placeholder for symmetry
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // App Icon and Version
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Trust Wallet',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // About Info
                  _AboutInfoTile(
                    label: 'Website',
                    value: 'trustwallet.com',
                    onTap: () => _openWebsite(context),
                  ),
                  _dividerLine(),
                  _AboutInfoTile(
                    label: 'Privacy Policy',
                    value: '',
                    onTap: () => _openPrivacyPolicy(context),
                  ),
                  _dividerLine(),
                  _AboutInfoTile(
                    label: 'Terms of Service',
                    value: '',
                    onTap: () => _openTermsOfService(context),
                  ),
                  _dividerLine(),
                  _AboutInfoTile(
                    label: 'Open Source Licenses',
                    value: '',
                    onTap: () => _showOpenSourceLicenses(context),
                  ),

                  const SizedBox(height: 32),

                  // Team Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Trust Wallet is the most trusted and secure crypto wallet. '
                      'Buy, store, collect NFTs, exchange & earn crypto. '
                      'Join 10 million+ people using Trust Wallet.',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
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
  }

  static Widget _dividerLine() {
    return Container(
      height: 1,
      color: AppColors.divider,
      margin: const EdgeInsets.only(left: 16, right: 16),
    );
  }

  static void _openWebsite(BuildContext context) {
    // In real app, use url_launcher
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening trustwallet.com'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  static void _openPrivacyPolicy(BuildContext context) {
    // In real app, use url_launcher
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Privacy Policy'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  static void _openTermsOfService(BuildContext context) {
    // In real app, use url_launcher
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Terms of Service'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  static void _showOpenSourceLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Trust Wallet',
      applicationVersion: '1.0.0',
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
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
              if (value.isNotEmpty)
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.primaryText),
            ],
          ),
        ),
      ),
    );
  }
}
