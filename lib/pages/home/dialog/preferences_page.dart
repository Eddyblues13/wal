import 'package:flutter/material.dart';
import 'package:wal/common/values/colors.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

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
                        'Preferences',
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
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 6),

                  // Appearance
                  _PreferencesTile(
                    label: 'Appearance',
                    value: 'System',
                    onTap: () => _showAppearanceDialog(context),
                  ),
                  _dividerLine(),

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

  static void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Select Currency',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['USD', 'EUR', 'GBP', 'JPY', 'CNY']
              .map(
                (currency) => ListTile(
                  title: Text(
                    currency,
                    style: TextStyle(color: AppColors.primaryText),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle currency selection
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  static void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Select Language',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'German', 'Chinese']
              .map(
                (language) => ListTile(
                  title: Text(
                    language,
                    style: TextStyle(color: AppColors.primaryText),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle language selection
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  static void _showAppearanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Appearance',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['System', 'Light', 'Dark']
              .map(
                (theme) => ListTile(
                  title: Text(
                    theme,
                    style: TextStyle(color: AppColors.primaryText),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle theme selection
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  static void _showDefaultWalletDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Default Wallet',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Main Wallet 1', 'Wallet 2', 'Wallet 3']
              .map(
                (wallet) => ListTile(
                  title: Text(
                    wallet,
                    style: TextStyle(color: AppColors.primaryText),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle wallet selection
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  static void _showAutoLockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Auto-lock',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              [
                    'Immediately',
                    'After 1 minute',
                    'After 5 minutes',
                    'After 15 minutes',
                  ]
                  .map(
                    (duration) => ListTile(
                      title: Text(
                        duration,
                        style: TextStyle(color: AppColors.primaryText),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // Handle auto-lock selection
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _PreferencesTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PreferencesTile({
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
              Text(
                value,
                style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
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
