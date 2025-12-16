// lib/pages/home/dialog/notifications_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'notification_history_page.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
                        'Notifications',
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

            // Notification Settings
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 6),

                  // Push Notifications
                  _NotificationSettingTile(
                    icon: Icons.notifications_active_outlined,
                    label: 'Push Notifications',
                    description: 'Receive alerts and updates',
                    isEnabled: true,
                    onChanged: (value) {
                      _showToggleMessage(context, 'Push Notifications', value);
                    },
                  ),
                  _dividerLine(),

                  // Price Alerts
                  _NotificationSettingTile(
                    icon: Icons.trending_up_outlined,
                    label: 'Price Alerts',
                    description: 'Get notified about price changes',
                    isEnabled: true,
                    onChanged: (value) {
                      _showToggleMessage(context, 'Price Alerts', value);
                    },
                  ),
                  _dividerLine(),

                  // Security Alerts
                  _NotificationSettingTile(
                    icon: Icons.security_outlined,
                    label: 'Security Alerts',
                    description: 'Important security notifications',
                    isEnabled: true,
                    onChanged: (value) {
                      _showToggleMessage(context, 'Security Alerts', value);
                    },
                  ),
                  _dividerLine(),

                  // Transaction Notifications
                  _NotificationSettingTile(
                    icon: Icons.swap_horiz_outlined,
                    label: 'Transaction Notifications',
                    description: 'Get updates on your transactions',
                    isEnabled: false,
                    onChanged: (value) {
                      _showToggleMessage(
                        context,
                        'Transaction Notifications',
                        value,
                      );
                    },
                  ),
                  _dividerLine(),

                  // Earn & Staking Notifications
                  _NotificationSettingTile(
                    icon: Icons.savings_outlined,
                    label: 'Earn & Staking',
                    description: 'Updates on your earnings and rewards',
                    isEnabled: true,
                    onChanged: (value) {
                      _showToggleMessage(context, 'Earn & Staking', value);
                    },
                  ),
                  _dividerLine(),

                  // Wallet Activity
                  _NotificationSettingTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet Activity',
                    description: 'Notifications for wallet operations',
                    isEnabled: true,
                    onChanged: (value) {
                      _showToggleMessage(context, 'Wallet Activity', value);
                    },
                  ),

                  // Separator
                  const SizedBox(height: 16),
                  Container(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),

                  // Notification History
                  _SettingsTile(
                    icon: const Icon(
                      Icons.history_outlined,
                      color: AppColors.primaryText,
                      size: 22,
                    ),
                    label: 'Notification History',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationHistoryPage(),
                      ),
                    ),
                  ),
                  _dividerLine(),

                  // Clear All Notifications
                  _SettingsTile(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.primaryText,
                      size: 22,
                    ),
                    label: 'Clear All Notifications',
                    onTap: () => _showClearAllDialog(context),
                  ),

                  const SizedBox(height: 20),

                  // Notification Preferences Info
                  _buildPreferencesInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildPreferencesInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'Notification Preferences',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your notification settings to stay updated about your wallet activity, '
            'price changes, security alerts, and earning opportunities.',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static void _showToggleMessage(
    BuildContext context,
    String setting,
    bool value,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting ${value ? 'enabled' : 'disabled'}'),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Clear All Notifications',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all notification history? This action cannot be undone.',
          style: TextStyle(color: AppColors.secondaryText, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.background,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryColor,
                  content: Text(
                    'All notifications cleared',
                    style: TextStyle(color: AppColors.background),
                  ),
                ),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isEnabled;
  final Function(bool) onChanged;

  const _NotificationSettingTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  State<_NotificationSettingTile> createState() =>
      _NotificationSettingTileState();
}

class _NotificationSettingTileState extends State<_NotificationSettingTile> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(widget.icon, color: AppColors.primaryText, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isEnabled,
              onChanged: (value) {
                setState(() {
                  _isEnabled = value;
                });
                widget.onChanged(value);
              },
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Single settings tile (icon left, label center, chevron right)
class _SettingsTile extends StatelessWidget {
  final Widget? icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({this.icon, required this.label, required this.onTap});

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
              icon ??
                  const Icon(
                    Icons.circle,
                    color: AppColors.primaryText,
                    size: 20,
                  ),
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
