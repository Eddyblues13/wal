import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';

class TopTabs extends StatelessWidget {
  final int selected;
  final void Function(int) onTap;

  const TopTabs({Key? key, required this.selected, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = ['Stake Hub', 'My Staking'];
    return Row(
      children: List.generate(tabs.length, (i) {
        final isSelected = selected == i;
        return GestureDetector(
          onTap: () => onTap(i),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[i],
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryText : AppColors.muted,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                // underline
                Container(
                  width: 26.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class PromoCard extends StatelessWidget {
  const PromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryText),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade300],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.trending_up,
                color: AppColors.primaryText,
                size: 28.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stake Your Assets & Earn Daily Rewards',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Up to 0.7% daily returns + referral bonuses',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.primaryText),
        ],
      ),
    );
  }
}

/// Staking package tile
class StakingPackageTile extends StatelessWidget {
  final String token;
  final String chain;
  final String dailyReward;
  final String minStake;
  final String duration;
  final VoidCallback onStake;

  const StakingPackageTile({
    Key? key,
    required this.token,
    required this.chain,
    required this.dailyReward,
    required this.minStake,
    required this.duration,
    required this.onStake,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.muted.withOpacity(0.3)),
        ),
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.primaryText,
              child: Text(
                token.substring(0, 3).toUpperCase(),
                style: TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        token,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.purpleBadge,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Text(
                          chain,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Min: $minStake • $duration',
                    style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Daily Reward: $dailyReward',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onStake,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              child: Text(
                'Stake',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Active staking position tile
class StakingPositionTile extends StatelessWidget {
  final String token;
  final String amount;
  final String dailyReward;
  final String totalEarned;
  final String daysRemaining;

  const StakingPositionTile({
    Key? key,
    required this.token,
    required this.amount,
    required this.dailyReward,
    required this.totalEarned,
    required this.daysRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.muted.withOpacity(0.3)),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.primaryText,
                  child: Text(
                    token.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  token,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '$daysRemaining days left',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric('Staked Amount', amount),
                _buildMetric('Daily Reward', dailyReward),
                _buildMetric('Total Earned', totalEarned),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
        ),
        SizedBox(height: 4.h),
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
}

/// Referral rewards section
class ReferralRewardsCard extends StatelessWidget {
  const ReferralRewardsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referral Rewards',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          _buildReferralTier('Generation 1', '0.2%'),
          _buildReferralTier('Generation 2', '0.1%'),
          _buildReferralTier('Generation 3', '0.1%'),
          SizedBox(height: 12.h),
          Text(
            'Earn additional rewards from your referral network',
            style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralTier(String tier, String reward) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tier,
              style: TextStyle(color: AppColors.primaryText, fontSize: 14.sp),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              reward,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
