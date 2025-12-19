// lib/pages/earn/earn.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/earn/bloc/stake_bloc.dart';
import 'package:wal/pages/earn/bloc/stake_state.dart';
import 'package:wal/pages/earn/stake_controller.dart';
import 'package:wal/pages/earn/widgets/earn_widgets.dart';

class StakePage extends StatefulWidget {
  const StakePage({Key? key}) : super(key: key);

  @override
  State<StakePage> createState() => _StakePageState();
}

class _StakePageState extends State<StakePage> {
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StakeBloc(),
      child: Builder(
        builder: (blocContext) {
          // Load stake data once when bloc is available
          if (!_hasInitialized) {
            _hasInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                StakeController(context: blocContext).loadStakeData();
              }
            });
          }
          
          return BlocListener<StakeBloc, StakeState>(
            listenWhen: (previous, current) {
              // Only listen to specific state changes to prevent infinite loops
              return (previous.stakeSuccess != current.stakeSuccess && current.stakeSuccess) ||
                  (previous.stakeError != current.stakeError && current.stakeError.isNotEmpty && !current.isStaking) ||
                  (previous.claimSuccess != current.claimSuccess && current.claimSuccess) ||
                  (previous.claimError != current.claimError && current.claimError.isNotEmpty && !current.isClaiming);
            },
            listener: (context, state) {
              // Handle stake success
              if (state.stakeSuccess && state.stakeMessage.isNotEmpty) {
                // Refresh stake data after successful stake
                if (context.mounted) {
                  StakeController(context: context).refreshStakeData();
                  // Reset stake state after showing message
                  Future.delayed(const Duration(seconds: 2), () {
                    if (context.mounted) {
                      context.read<StakeBloc>().resetStake();
                    }
                  });
                }
              }
              // Handle stake error
              if (state.stakeError.isNotEmpty && !state.isStaking) {
                // Reset stake state after showing error
                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) {
                    context.read<StakeBloc>().resetStake();
                  }
                });
              }
              // Handle claim success
              if (state.claimSuccess && state.claimMessage.isNotEmpty) {
                // Refresh stake data after successful claim
                if (context.mounted) {
                  StakeController(context: context).refreshStakeData();
                  // Reset claim state after showing message
                  Future.delayed(const Duration(seconds: 2), () {
                    if (context.mounted) {
                      context.read<StakeBloc>().resetClaim();
                    }
                  });
                }
              }
              // Handle claim error
              if (state.claimError.isNotEmpty && !state.isClaiming) {
                // Reset claim state after showing error
                Future.delayed(const Duration(seconds: 2), () {
                  if (context.mounted) {
                    context.read<StakeBloc>().resetClaim();
                  }
                });
              }
            },
            child: BlocBuilder<StakeBloc, StakeState>(
              builder: (context, state) {
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
                body: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      )
                    : SafeArea(
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
                                selected: state.selectedTab,
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
                                    if (state.selectedTab == 0) ...[
                                      _buildSectionHeader(
                                        'Available Staking Packages',
                                        'Stake for 365 days and earn daily rewards',
                                      ),
                                      SizedBox(height: 16.h),
                                      _buildStakingPackagesSection(context, state),
                                      SizedBox(height: 24.h),

                                      _buildSectionHeader(
                                        'Referral Rewards',
                                        'Earn additional rewards from your network',
                                      ),
                                      SizedBox(height: 16.h),
                                      const ReferralRewardsCard(),
                                    ] else ...[
                                      _buildMyStakingSection(state),
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
  Widget _buildStakingPackagesSection(BuildContext context, StakeState state) {
    final stakingPackages = state.stakingPackages;

    if (stakingPackages.isEmpty) {
      return Center(
        child: Text(
          'No staking packages available',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return Column(
      children: stakingPackages
          .map(
            (package) => StakingPackageTile(
              token: package['token'] as String? ?? '',
              chain: package['chain'] as String? ?? '',
              dailyReward: package['dailyReward'] as String? ?? '',
              minStake: package['minStake'] as String? ?? '',
              duration: package['duration'] as String? ?? '',
              onStake: () => _showStakeDialog(context, package['token'] as String? ?? ''),
            ),
          )
          .toList(),
    );
  }

  /// --- My Staking Section ---
  Widget _buildMyStakingSection(StakeState state) {
    final activePositions = state.activePositions;

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
                    token: position['token'] as String? ?? '',
                    amount: position['amount'] as String? ?? '',
                    dailyReward: position['dailyReward'] as String? ?? '',
                    totalEarned: position['totalEarned'] as String? ?? '',
                    daysRemaining: position['daysRemaining'] as String? ?? '',
                    positionId: position['positionId'] as String?,
                    onClaim: () {
                      StakeController(context: context).claimRewards(
                        positionId: position['positionId'] as String?,
                      );
                    },
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 24.h),
          
          /// Claim All Button
          if (activePositions.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<StakeBloc, StakeState>(
                builder: (context, stakeState) {
                  return ElevatedButton(
                    onPressed: stakeState.isClaiming
                        ? null
                        : () {
                            StakeController(context: context).claimRewards();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      disabledBackgroundColor: AppColors.muted,
                    ),
                    child: stakeState.isClaiming
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Claim Total Earned STARCOIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
          ],
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
                '${state.totalStaked} STAR',
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
                  _buildStakingMetric('Total Staked', '${state.totalStaked} STAR'),
                  _buildStakingMetric('Daily Rewards', '${state.totalDailyRewards} STAR'),
                  _buildStakingMetric('Total Earned', '${state.totalEarned} STAR'),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStakingMetric('Referral Rewards', '${state.referralRewards} STAR'),
                  _buildStakingMetric('Active Positions', '${activePositions.length}'),
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

  void _showStakeDialog(BuildContext context, String token) {
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    double? calculatedDailyReward;

    void calculateDailyReward(String amount, StakeState state) {
      final value = double.tryParse(amount);
      if (value != null && value >= 10) {
        // Use reward tiers from state if available
        final tiers = state.rewardTiers;
        if (tiers.isNotEmpty) {
          for (var tier in tiers) {
            final min = double.tryParse(tier.minAmount) ?? 0;
            final max = double.tryParse(tier.maxAmount) ?? double.infinity;
            final dailyRate = double.tryParse(tier.dailyReward) ?? 0;
            if (value >= min && value <= max) {
              calculatedDailyReward = value * (dailyRate / 100);
              break;
            }
          }
        } else {
          // Fallback to default tiers
          if (value >= 1000) {
            calculatedDailyReward = value * 0.007; // 0.7%
          } else if (value >= 100) {
            calculatedDailyReward = value * 0.006; // 0.6%
          } else {
            calculatedDailyReward = value * 0.005; // 0.5%
          }
        }
      } else {
        calculatedDailyReward = null;
      }
    }

    showDialog(
      context: context,
      builder: (context) => BlocBuilder<StakeBloc, StakeState>(
        builder: (context, state) {
          return StatefulBuilder(
            builder: (dialogContext, setState) {
              return AlertDialog(
                title: Text(
                  'Stake STARCOIN',
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
                      _buildInfoRow('Minimum Stake', '10 STAR'),
                      SizedBox(height: 8.h),
                      _buildInfoRow('Network', 'TON Chain'),
                      SizedBox(height: 16.h),

                      TextFormField(
                        controller: amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount to Stake (STARCOIN)',
                          labelStyle: TextStyle(color: AppColors.secondaryText),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: AppColors.muted),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: AppColors.primaryColor),
                          ),
                          suffixText: 'STARCOIN',
                          suffixStyle: TextStyle(
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
                            calculateDailyReward(value, state);
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
                            return 'Minimum stake is 10 STARCOIN';
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
                                '${calculatedDailyReward!.toStringAsFixed(2)} STAR',
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
                      _buildTierInfo(context, state),
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
                  BlocBuilder<StakeBloc, StakeState>(
                    builder: (context, stakeState) {
                      return ElevatedButton(
                        onPressed: stakeState.isStaking
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  final amount = amountController.text;
                                  Navigator.pop(context);
                                  // Call controller to stake
                                  StakeController(context: context).stakeTokens(
                                    amount,
                                    'STARCOIN',
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          disabledBackgroundColor: AppColors.muted,
                        ),
                        child: stakeState.isStaking
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Confirm Stake',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTierInfo(BuildContext context, StakeState state) {
    final tiers = state.rewardTiers;
    
    if (tiers.isEmpty) {
      // Default tiers if API hasn't loaded yet
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
          _buildTierItem('10 - 99 STAR', '0.5% daily'),
          _buildTierItem('100 - 999 STAR', '0.6% daily'),
          _buildTierItem('1000+ STAR', '0.7% daily'),
        ],
      );
    }

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
        ...tiers.map((tier) => _buildTierItem(
              '${tier.minAmount} - ${tier.maxAmount} STAR',
              '${tier.dailyReward}% daily',
            )),
      ],
    );
  }

  Widget _buildTierItem(String range, String reward) {
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

}
