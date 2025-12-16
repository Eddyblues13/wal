class WalletState {
  const WalletState({
    this.selectedTab = 'Crypto',
    this.bottomNavIndex = 0,
    this.isLoading = false,
    this.balance = 0.0,
    this.portfolioValue = 0.0,
    this.portfolioChange = 0.0,
  });

  final String selectedTab;
  final int bottomNavIndex;
  final bool isLoading;
  final double balance;
  final double portfolioValue;
  final double portfolioChange;

  WalletState copyWith({
    String? selectedTab,
    int? bottomNavIndex,
    bool? isLoading,
    double? balance,
    double? portfolioValue,
    double? portfolioChange,
  }) {
    return WalletState(
      selectedTab: selectedTab ?? this.selectedTab,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      isLoading: isLoading ?? this.isLoading,
      balance: balance ?? this.balance,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      portfolioChange: portfolioChange ?? this.portfolioChange,
    );
  }
}
