// stake_event.dart
abstract class StakeEvent {
  const StakeEvent();
}

class LoadStakeDataEvent extends StakeEvent {
  final String walletAddress;
  const LoadStakeDataEvent(this.walletAddress);
}

class RefreshStakeDataEvent extends StakeEvent {
  final String walletAddress;
  const RefreshStakeDataEvent(this.walletAddress);
}

class ChangeTabEvent extends StakeEvent {
  final int tabIndex;
  const ChangeTabEvent(this.tabIndex);
}

class SelectStakingPackageEvent extends StakeEvent {
  final Map<String, dynamic> package;
  const SelectStakingPackageEvent(this.package);
}

class StakeTokensEvent extends StakeEvent {
  final String amount;
  final String coinSymbol;
  const StakeTokensEvent(this.amount, this.coinSymbol);
}

class StakeSuccessEvent extends StakeEvent {
  final String message;
  const StakeSuccessEvent(this.message);
}

class StakeErrorEvent extends StakeEvent {
  final String error;
  const StakeErrorEvent(this.error);
}

class LoadDailyReturnEvent extends StakeEvent {
  const LoadDailyReturnEvent();
}

class LoadRewardTiersEvent extends StakeEvent {
  const LoadRewardTiersEvent();
}

class ClaimRewardsEvent extends StakeEvent {
  final String? positionId;
  const ClaimRewardsEvent({this.positionId});
}

class ClaimSuccessEvent extends StakeEvent {
  final String message;
  final String? claimedAmount;
  const ClaimSuccessEvent(this.message, {this.claimedAmount});
}

class ClaimErrorEvent extends StakeEvent {
  final String error;
  const ClaimErrorEvent(this.error);
}

class ResetStakeEvent extends StakeEvent {
  const ResetStakeEvent();
}

class ResetClaimEvent extends StakeEvent {
  const ResetClaimEvent();
}

class LoadingEvent extends StakeEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ErrorEvent extends StakeEvent {
  final String error;
  const ErrorEvent(this.error);
}

