// stake_state.dart
import 'package:wal/common/entities/stake.dart';

class StakeState {
  const StakeState({
    this.isLoading = false,
    this.error = "",
    this.selectedTab = 0,
    this.stakingPackages = const [],
    this.activePositions = const [],
    this.totalStaked = "0.00",
    this.totalDailyRewards = "0.00",
    this.totalEarned = "0.00",
    this.referralRewards = "0.00",
    this.selectedPackage,
    this.dailyReturn = "0.00",
    this.rewardTiers = const [],
    this.isStaking = false,
    this.stakeSuccess = false,
    this.stakeError = "",
    this.stakeMessage = "",
    this.isClaiming = false,
    this.claimSuccess = false,
    this.claimError = "",
    this.claimMessage = "",
  });

  final bool isLoading;
  final String error;
  final int selectedTab; // 0 = Stake Hub, 1 = My Staking
  final List<Map<String, dynamic>> stakingPackages;
  final List<Map<String, dynamic>> activePositions;
  final String totalStaked;
  final String totalDailyRewards;
  final String totalEarned;
  final String referralRewards;
  final Map<String, dynamic>? selectedPackage;
  final String dailyReturn;
  final List<RewardTierEntity> rewardTiers;
  final bool isStaking;
  final bool stakeSuccess;
  final String stakeError;
  final String stakeMessage;
  final bool isClaiming;
  final bool claimSuccess;
  final String claimError;
  final String claimMessage;

  StakeState copyWith({
    bool? isLoading,
    String? error,
    int? selectedTab,
    List<Map<String, dynamic>>? stakingPackages,
    List<Map<String, dynamic>>? activePositions,
    String? totalStaked,
    String? totalDailyRewards,
    String? totalEarned,
    String? referralRewards,
    Map<String, dynamic>? selectedPackage,
    String? dailyReturn,
    List<RewardTierEntity>? rewardTiers,
    bool? isStaking,
    bool? stakeSuccess,
    String? stakeError,
    String? stakeMessage,
    bool? isClaiming,
    bool? claimSuccess,
    String? claimError,
    String? claimMessage,
  }) {
    return StakeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedTab: selectedTab ?? this.selectedTab,
      stakingPackages: stakingPackages ?? this.stakingPackages,
      activePositions: activePositions ?? this.activePositions,
      totalStaked: totalStaked ?? this.totalStaked,
      totalDailyRewards: totalDailyRewards ?? this.totalDailyRewards,
      totalEarned: totalEarned ?? this.totalEarned,
      referralRewards: referralRewards ?? this.referralRewards,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      dailyReturn: dailyReturn ?? this.dailyReturn,
      rewardTiers: rewardTiers ?? this.rewardTiers,
      isStaking: isStaking ?? this.isStaking,
      stakeSuccess: stakeSuccess ?? this.stakeSuccess,
      stakeError: stakeError ?? this.stakeError,
      stakeMessage: stakeMessage ?? this.stakeMessage,
      isClaiming: isClaiming ?? this.isClaiming,
      claimSuccess: claimSuccess ?? this.claimSuccess,
      claimError: claimError ?? this.claimError,
      claimMessage: claimMessage ?? this.claimMessage,
    );
  }

  @override
  String toString() {
    return 'StakeState{isLoading: $isLoading, error: $error, selectedTab: $selectedTab, packages: ${stakingPackages.length}, positions: ${activePositions.length}}';
  }
}

