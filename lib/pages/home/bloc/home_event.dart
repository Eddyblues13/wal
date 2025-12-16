abstract class HomeEvent {
  const HomeEvent();
}

class HomeLoadData extends HomeEvent {
  const HomeLoadData();
}

class HomeLoadWalletData extends HomeEvent {
  // NEW: Load wallet data from API
  final String walletAddress;
  const HomeLoadWalletData(this.walletAddress);
}

class HomeTabChanged extends HomeEvent {
  final String tab;
  const HomeTabChanged(this.tab);
}

class HomeBuyCrypto extends HomeEvent {
  const HomeBuyCrypto();
}

class HomeDepositCrypto extends HomeEvent {
  const HomeDepositCrypto();
}

class HomeManageCrypto extends HomeEvent {
  const HomeManageCrypto();
}

class HomeReceiveNFTs extends HomeEvent {
  const HomeReceiveNFTs();
}

class HomeSendCrypto extends HomeEvent {
  const HomeSendCrypto();
}

class HomeReceiveCrypto extends HomeEvent {
  const HomeReceiveCrypto();
}

class HomeSwapCrypto extends HomeEvent {
  const HomeSwapCrypto();
}

class HomeLoadProfile extends HomeEvent {
  const HomeLoadProfile();
}

class HomeCopyReferralCode extends HomeEvent {
  const HomeCopyReferralCode();
}

class HomeRefreshData extends HomeEvent {
  // NEW: Refresh all data
  const HomeRefreshData();
}
