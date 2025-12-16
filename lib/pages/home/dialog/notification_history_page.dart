// lib/pages/home/dialog/notification_history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';

class NotificationHistoryPage extends StatelessWidget {
  const NotificationHistoryPage({super.key});

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
                        'Notification History',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Clear All button
                  InkWell(
                    onTap: () => _showClearAllDialog(context),
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
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 6),

                  // Today Section
                  _buildDateSection('Today', _todayNotifications()),

                  // Yesterday Section
                  _buildDateSection('Yesterday', _yesterdayNotifications()),

                  // This Week Section
                  _buildDateSection('This Week', _thisWeekNotifications()),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(
    String title,
    List<Map<String, dynamic>> notifications,
  ) {
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Notifications List
        Column(
          children: notifications
              .map(
                (notification) => _NotificationItem(
                  title: notification['title'] as String,
                  description: notification['description'] as String,
                  time: notification['time'] as String,
                  type: notification['type'] as String,
                  isRead: notification['isRead'] as bool,
                  icon: notification['icon'] as IconData,
                ),
              )
              .toList(),
        ),

        // Section Divider
        Container(
          height: 1,
          color: AppColors.divider,
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _todayNotifications() {
    return [
      {
        'title': 'Swap Completed',
        'description':
            'Your swap of 100 TAP to 17 USDT has been completed successfully',
        'time': '2 hours ago',
        'type': 'transaction',
        'isRead': true,
        'icon': Icons.swap_horiz,
      },
      {
        'title': 'Price Alert: STAR',
        'description': 'STAR has increased by 5.2% in the last 24 hours',
        'time': '4 hours ago',
        'type': 'price',
        'isRead': true,
        'icon': Icons.trending_up,
      },
      {
        'title': 'Staking Reward',
        'description': 'You earned 2.5 TAP from staking rewards',
        'time': '6 hours ago',
        'type': 'earn',
        'isRead': false,
        'icon': Icons.savings,
      },
      {
        'title': 'Wallet Backup Reminder',
        'description': 'Secure your assets by backing up your recovery phrase',
        'time': '8 hours ago',
        'type': 'security',
        'isRead': true,
        'icon': Icons.security,
      },
    ];
  }

  List<Map<String, dynamic>> _yesterdayNotifications() {
    return [
      {
        'title': 'Security Update',
        'description':
            'New security features are available. Update your settings for enhanced protection',
        'time': 'Yesterday, 14:30',
        'type': 'security',
        'isRead': true,
        'icon': Icons.security,
      },
      {
        'title': 'TON Staking Started',
        'description': 'Your TON staking has begun. Expected APR: 7.02%',
        'time': 'Yesterday, 11:15',
        'type': 'earn',
        'isRead': true,
        'icon': Icons.rocket_launch,
      },
      {
        'title': 'USDT Earn Opportunity',
        'description': 'New USDT earning pool available with up to 4.41% APY',
        'time': 'Yesterday, 09:45',
        'type': 'earn',
        'isRead': true,
        'icon': Icons.account_balance_wallet,
      },
    ];
  }

  List<Map<String, dynamic>> _thisWeekNotifications() {
    return [
      {
        'title': 'Network Fee Update',
        'description': 'Network fees have decreased on TAP transactions',
        'time': '3 days ago',
        'type': 'system',
        'isRead': true,
        'icon': Icons.settings,
      },
      {
        'title': 'New Feature: Earn Hub',
        'description':
            'Check out the new Earn Hub for better staking opportunities',
        'time': '4 days ago',
        'type': 'system',
        'isRead': true,
        'icon': Icons.new_releases,
      },
      {
        'title': 'Successful Transfer',
        'description': 'You received 50 USDT from external wallet',
        'time': '5 days ago',
        'type': 'transaction',
        'isRead': true,
        'icon': Icons.call_received,
      },
    ];
  }

  void _showClearAllDialog(BuildContext context) {
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

class _NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String type;
  final bool isRead;
  final IconData icon;

  const _NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    required this.isRead,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color getIconColor() {
      switch (type) {
        case 'transaction':
          return AppColors.primaryColor;
        case 'price':
          return Colors.green;
        case 'earn':
          return Colors.orange;
        case 'security':
          return Colors.red;
        case 'system':
          return AppColors.secondaryText;
        default:
          return AppColors.primaryColor;
      }
    }

    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: () {
          // Handle notification tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing: $title'),
              backgroundColor: AppColors.primaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: getIconColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(icon, color: getIconColor(), size: 20),
                ),
              ),
              const SizedBox(width: 12),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 16.sp,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
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
