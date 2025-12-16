import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/earn/bloc/earn_bloc.dart';
import 'package:wal/pages/earn/widgets/earn_widgets.dart';

class StakePage extends StatelessWidget {
  const StakePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StakeBloc(),
      child: BlocBuilder<StakeBloc, int>(
        builder: (context, selectedTab) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text(
                'Stake',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  /// --- Top Tabs ---
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.muted.withOpacity(0.3),
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: TopTabs(
                      selected: selectedTab,
                      onTap: (i) => context.read<StakeBloc>().updateIndex(i),
                    ),
                  ),

                  /// --- Scrollable Content ---
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// --- Promo Banner ---
                          const PromoCard(),
                          SizedBox(height: 24.h),

                          /// --- Tab Content ---
                          if (selectedTab == 0) ...[
                            _buildSectionHeader(
                              'Available Staking Packages',
                              'Stake for 365 days and earn daily rewards',
                            ),
                            SizedBox(height: 16.h),
                            _buildStakingPackagesSection(context),
                            SizedBox(height: 24.h),

                            _buildSectionHeader(
                              'Referral Rewards',
                              'Earn additional rewards from your network',
                            ),
                            SizedBox(height: 16.h),
                            const ReferralRewardsCard(),
                          ] else ...[
                            _buildMyStakingSection(),
                          ],

                          SizedBox(height: 50.h), // Extra bottom space
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// --- Reusable Section Header ---
  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 13.sp),
        ),
      ],
    );
  }

  /// --- Staking Packages Section ---
  Widget _buildStakingPackagesSection(BuildContext context) {
    final stakingPackages = [
      {
        'token': 'STAR',
        'chain': 'TON Chain',
        'dailyReward': '0.5% - 0.7%',
        'minStake': '\$10',
        'duration': '365 Days',
      },
      {
        'token': 'TON',
        'chain': 'TON Chain',
        'dailyReward': '0.5% - 0.7%',
        'minStake': '\$10',
        'duration': '365 Days',
      },
      {
        'token': 'USDT',
        'chain': 'TON Chain',
        'dailyReward': '0.5% - 0.7%',
        'minStake': '\$10',
        'duration': '365 Days',
      },
    ];

    return Column(
      children: stakingPackages
          .map(
            (package) => StakingPackageTile(
              token: package['token'] as String,
              chain: package['chain'] as String,
              dailyReward: package['dailyReward'] as String,
              minStake: package['minStake'] as String,
              duration: package['duration'] as String,
              onStake: () =>
                  _showStakeDialog(context, package['token'] as String),
            ),
          )
          .toList(),
    );
  }

  /// --- My Staking Section ---
  Widget _buildMyStakingSection() {
    final activePositions = [
      {
        'token': 'STAR',
        'amount': '\$150.00',
        'dailyReward': '\$0.90',
        'totalEarned': '\$45.50',
        'daysRemaining': '320',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'My Staking Positions',
          'Track your active staking positions and rewards',
        ),
        SizedBox(height: 24.h),

        if (activePositions.isEmpty) ...[
          /// No Active Positions
          Container(
            height: 180.h,
            margin: EdgeInsets.only(bottom: 24.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.muted.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 48.sp,
                  color: AppColors.secondaryText,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No active staking positions',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start staking to earn daily rewards',
                  style: TextStyle(color: AppColors.muted, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ] else ...[
          /// Active Positions List
          Column(
            children: activePositions
                .map(
                  (position) => StakingPositionTile(
                    token: position['token'] as String,
                    amount: position['amount'] as String,
                    dailyReward: position['dailyReward'] as String,
                    totalEarned: position['totalEarned'] as String,
                    daysRemaining: position['daysRemaining'] as String,
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 24.h),
        ],

        /// Total Staking Summary
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Staking Portfolio',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '\$150.00',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStakingMetric('Total Staked', '\$150.00'),
                  _buildStakingMetric('Daily Rewards', '\$0.90'),
                  _buildStakingMetric('Total Earned', '\$45.50'),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStakingMetric('Referral Rewards', '\$12.30'),
                  _buildStakingMetric('Active Positions', '1'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStakingMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 12.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static void _showStakeDialog(BuildContext context, String token) {
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    double? calculatedDailyReward;

    void calculateDailyReward(String amount) {
      final value = double.tryParse(amount);
      if (value != null && value >= 10) {
        if (value >= 1000) {
          calculatedDailyReward = value * 0.007; // 0.7%
        } else if (value >= 100) {
          calculatedDailyReward = value * 0.006; // 0.6%
        } else {
          calculatedDailyReward = value * 0.005; // 0.5%
        }
      } else {
        calculatedDailyReward = null;
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Stake $token',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Staking Package', '365 Days'),
                  SizedBox(height: 8.h),
                  _buildInfoRow('Minimum Stake', '\$10'),
                  SizedBox(height: 8.h),
                  _buildInfoRow('Network', 'TON Chain'),
                  SizedBox(height: 16.h),

                  TextFormField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount to Stake',
                      labelStyle: TextStyle(color: AppColors.secondaryText),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppColors.muted),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      prefixText: '\$',
                      prefixStyle: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16.sp,
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        calculateDailyReward(value);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Please enter a valid number';
                      }
                      if (amount < 10) {
                        return 'Minimum stake is \$10';
                      }
                      return null;
                    },
                  ),

                  if (calculatedDailyReward != null) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Daily Reward:',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '\$${calculatedDailyReward!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'APR: ${(calculatedDailyReward! / (double.tryParse(amountController.text) ?? 1) * 365 * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 12.h),
                  _buildTierInfo(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.muted, fontSize: 14.sp),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final amount = double.parse(amountController.text);
                    Navigator.pop(context);
                    _showStakingSuccess(context, token, amount);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Confirm Stake',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 14.sp),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static Widget _buildTierInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reward Tiers:',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        _buildTierItem('\$10 - \$99', '0.5% daily'),
        _buildTierItem('\$100 - \$999', '0.6% daily'),
        _buildTierItem('\$1000+', '0.7% daily'),
      ],
    );
  }

  static Widget _buildTierItem(String range, String reward) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              range,
              style: TextStyle(color: AppColors.primaryText, fontSize: 12.sp),
            ),
          ),
          Text(
            reward,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static void _showStakingSuccess(
    BuildContext context,
    String token,
    double amount,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staking Successful!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'You staked \$${amount.toStringAsFixed(2)} in $token for 365 days',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
