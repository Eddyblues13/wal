abstract class WalletEvent {
  const WalletEvent();
}

class WalletTabChanged extends WalletEvent {
  final String tab;
  const WalletTabChanged(this.tab);
}

class WalletNavIndexChanged extends WalletEvent {
  final int index;
  const WalletNavIndexChanged(this.index);
}

class WalletLoadData extends WalletEvent {
  const WalletLoadData();
}

class WalletBuyCrypto extends WalletEvent {
  const WalletBuyCrypto();
}

class WalletDepositCrypto extends WalletEvent {
  const WalletDepositCrypto();
}

class WalletManageCrypto extends WalletEvent {
  const WalletManageCrypto();
}

class WalletReceiveNFTs extends WalletEvent {
  const WalletReceiveNFTs();
}
