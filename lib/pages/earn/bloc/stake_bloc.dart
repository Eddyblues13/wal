// stake_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/entities/stake.dart';
import 'package:wal/pages/earn/bloc/stake_event.dart';
import 'package:wal/pages/earn/bloc/stake_state.dart';

// Internal event for setting stake data
class _SetStakeDataEvent extends StakeEvent {
  final List<Map<String, dynamic>> stakingPackages;
  final List<Map<String, dynamic>> activePositions;
  final String totalStaked;
  final String totalDailyRewards;
  final String totalEarned;
  final String referralRewards;
  
  const _SetStakeDataEvent(
    this.stakingPackages,
    this.activePositions,
    this.totalStaked,
    this.totalDailyRewards,
    this.totalEarned,
    this.referralRewards,
  );
}

// Internal event for setting daily return
class _SetDailyReturnEvent extends StakeEvent {
  final String dailyReturn;
  const _SetDailyReturnEvent(this.dailyReturn);
}

// Internal event for setting reward tiers
class _SetRewardTiersEvent extends StakeEvent {
  final List<RewardTierEntity> tiers;
  const _SetRewardTiersEvent(this.tiers);
}

class StakeBloc extends Bloc<StakeEvent, StakeState> {
  StakeBloc() : super(const StakeState()) {
    on<LoadStakeDataEvent>(_onLoadStakeData);
    on<RefreshStakeDataEvent>(_onRefreshStakeData);
    on<ChangeTabEvent>(_onChangeTab);
    on<SelectStakingPackageEvent>(_onSelectStakingPackage);
    on<StakeTokensEvent>(_onStakeTokens);
    on<StakeSuccessEvent>(_onStakeSuccess);
    on<StakeErrorEvent>(_onStakeError);
    on<LoadDailyReturnEvent>(_onLoadDailyReturn);
    on<LoadRewardTiersEvent>(_onLoadRewardTiers);
    on<ClaimRewardsEvent>(_onClaimRewards);
    on<ClaimSuccessEvent>(_onClaimSuccess);
    on<ClaimErrorEvent>(_onClaimError);
    on<ResetStakeEvent>(_onResetStake);
    on<ResetClaimEvent>(_onResetClaim);
    on<LoadingEvent>(_onLoadingChanged);
    on<ErrorEvent>(_onErrorOccurred);
    on<_SetStakeDataEvent>(_onSetStakeData);
    on<_SetDailyReturnEvent>(_onSetDailyReturn);
    on<_SetRewardTiersEvent>(_onSetRewardTiers);
  }

  void _onSetStakeData(
    _SetStakeDataEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      stakingPackages: event.stakingPackages,
      activePositions: event.activePositions,
      totalStaked: event.totalStaked,
      totalDailyRewards: event.totalDailyRewards,
      totalEarned: event.totalEarned,
      referralRewards: event.referralRewards,
      isLoading: false,
      error: "",
    ));
  }

  void _onLoadStakeData(
    LoadStakeDataEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onRefreshStakeData(
    RefreshStakeDataEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onChangeTab(
    ChangeTabEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tabIndex));
  }

  void _onSelectStakingPackage(
    SelectStakingPackageEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(selectedPackage: event.package));
  }

  void _onStakeTokens(
    StakeTokensEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isStaking: true,
      stakeSuccess: false,
      stakeError: "",
      stakeMessage: "",
    ));
  }

  void _onStakeSuccess(
    StakeSuccessEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isStaking: false,
      stakeSuccess: true,
      stakeMessage: event.message,
      stakeError: "",
    ));
  }

  void _onStakeError(
    StakeErrorEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isStaking: false,
      stakeSuccess: false,
      stakeError: event.error,
      stakeMessage: event.error,
    ));
  }

  void _onLoadDailyReturn(
    LoadDailyReturnEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
  }

  void _onLoadRewardTiers(
    LoadRewardTiersEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
  }

  void _onClaimRewards(
    ClaimRewardsEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isClaiming: true,
      claimSuccess: false,
      claimError: "",
      claimMessage: "",
    ));
  }

  void _onClaimSuccess(
    ClaimSuccessEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isClaiming: false,
      claimSuccess: true,
      claimMessage: event.message,
      claimError: "",
    ));
  }

  void _onClaimError(
    ClaimErrorEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isClaiming: false,
      claimSuccess: false,
      claimError: event.error,
      claimMessage: event.error,
    ));
  }

  void _onResetStake(
    ResetStakeEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isStaking: false,
      stakeSuccess: false,
      stakeError: "",
      stakeMessage: "",
    ));
  }

  void _onResetClaim(
    ResetClaimEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      isClaiming: false,
      claimSuccess: false,
      claimError: "",
      claimMessage: "",
    ));
  }

  void _onSetDailyReturn(
    _SetDailyReturnEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      dailyReturn: event.dailyReturn,
      isLoading: false,
    ));
  }

  void _onSetRewardTiers(
    _SetRewardTiersEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      rewardTiers: event.tiers,
      isLoading: false,
    ));
  }

  void _onLoadingChanged(
    LoadingEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onErrorOccurred(
    ErrorEvent event,
    Emitter<StakeState> emit,
  ) {
    emit(state.copyWith(
      error: event.error,
      isLoading: false,
    ));
  }

  // Public methods
  void setStakeData(
    List<Map<String, dynamic>> stakingPackages,
    List<Map<String, dynamic>> activePositions,
    String totalStaked,
    String totalDailyRewards,
    String totalEarned,
    String referralRewards,
  ) {
    add(_SetStakeDataEvent(
      stakingPackages,
      activePositions,
      totalStaked,
      totalDailyRewards,
      totalEarned,
      referralRewards,
    ));
  }

  void setLoading(bool isLoading) {
    add(LoadingEvent(isLoading));
  }

  void setError(String error) {
    add(ErrorEvent(error));
  }

  void updateIndex(int index) {
    add(ChangeTabEvent(index));
  }

  void setDailyReturn(String dailyReturn) {
    add(_SetDailyReturnEvent(dailyReturn));
  }

  void setRewardTiers(List<RewardTierEntity> tiers) {
    add(_SetRewardTiersEvent(tiers));
  }

  void setStaking(bool isStaking) {
    if (isStaking) {
      add(const StakeTokensEvent('0', 'STARCOIN'));
    }
  }

  void setStakeSuccess(String message) {
    add(StakeSuccessEvent(message));
  }

  void setStakeError(String error) {
    add(StakeErrorEvent(error));
  }

  void setClaiming(bool isClaiming) {
    if (isClaiming) {
      add(const ClaimRewardsEvent());
    }
  }

  void setClaimSuccess(String message, {String? claimedAmount}) {
    add(ClaimSuccessEvent(message, claimedAmount: claimedAmount));
  }

  void setClaimError(String error) {
    add(ClaimErrorEvent(error));
  }

  void resetStake() {
    add(const ResetStakeEvent());
  }

  void resetClaim() {
    add(const ResetClaimEvent());
  }
}

