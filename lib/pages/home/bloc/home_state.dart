class HomeState {
  const HomeState({
    this.selectedTab = 'Crypto',
    this.isLoading = false,
    this.balance = 0.0,
    this.portfolioValue = 0.0,
    this.portfolioChange = 0.0,
    this.cryptoAssets = const [],
    this.nftAssets = const [],
    this.selectedAsset,
    this.userProfile,
    this.referralCode = '',
    this.isReferralCodeCopied = false,
    this.walletAddress = '',
    this.apiError = '',
    this.recentTransactions = const [],
  });

  final String selectedTab;
  final bool isLoading;
  final double balance;
  final double portfolioValue;
  final double portfolioChange;
  final List<Map<String, dynamic>> cryptoAssets;
  final List<Map<String, dynamic>> nftAssets;
  final Map<String, dynamic>? selectedAsset;
  final Map<String, dynamic>? userProfile;
  final String referralCode;
  final bool isReferralCodeCopied;
  final String walletAddress;
  final String apiError;
  final List<Map<String, dynamic>> recentTransactions;

  HomeState copyWith({
    String? selectedTab,
    bool? isLoading,
    double? balance,
    double? portfolioValue,
    double? portfolioChange,
    List<Map<String, dynamic>>? cryptoAssets,
    List<Map<String, dynamic>>? nftAssets,
    Map<String, dynamic>? selectedAsset,
    Map<String, dynamic>? userProfile,
    String? referralCode,
    bool? isReferralCodeCopied,
    String? walletAddress,
    String? apiError,
    List<Map<String, dynamic>>? recentTransactions, // NEW
  }) {
    return HomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      balance: balance ?? this.balance,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      portfolioChange: portfolioChange ?? this.portfolioChange,
      cryptoAssets: cryptoAssets ?? this.cryptoAssets,
      nftAssets: nftAssets ?? this.nftAssets,
      selectedAsset: selectedAsset ?? this.selectedAsset,
      userProfile: userProfile ?? this.userProfile,
      referralCode: referralCode ?? this.referralCode,
      isReferralCodeCopied: isReferralCodeCopied ?? this.isReferralCodeCopied,
      walletAddress: walletAddress ?? this.walletAddress,
      apiError: apiError ?? this.apiError,
      recentTransactions: recentTransactions ?? this.recentTransactions,
    );
  }
}
