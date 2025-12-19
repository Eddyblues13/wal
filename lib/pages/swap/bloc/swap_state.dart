// swap_state.dart
class SwapState {
  const SwapState({
    this.isLoading = false,
    this.error = "",
    this.availableAssets = const [],
    this.fromAsset,
    this.toAsset,
    this.fromAmount = "0.00",
    this.toAmount = "0.00",
    this.priceRate = "0.00",
    this.networkFee = "\$0.00",
    this.priceImpact = "0.00%",
    this.minimumReceived = "0.00",
    this.route = "STAR → USDT",
    this.recentSwaps = const [],
  });

  final bool isLoading;
  final String error;
  final List<Map<String, dynamic>> availableAssets;
  final Map<String, dynamic>? fromAsset;
  final Map<String, dynamic>? toAsset;
  final String fromAmount;
  final String toAmount;
  final String priceRate;
  final String networkFee;
  final String priceImpact;
  final String minimumReceived;
  final String route;
  final List<Map<String, dynamic>> recentSwaps;

  SwapState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? availableAssets,
    Map<String, dynamic>? fromAsset,
    Map<String, dynamic>? toAsset,
    String? fromAmount,
    String? toAmount,
    String? priceRate,
    String? networkFee,
    String? priceImpact,
    String? minimumReceived,
    String? route,
    List<Map<String, dynamic>>? recentSwaps,
  }) {
    return SwapState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      availableAssets: availableAssets ?? this.availableAssets,
      fromAsset: fromAsset ?? this.fromAsset,
      toAsset: toAsset ?? this.toAsset,
      fromAmount: fromAmount ?? this.fromAmount,
      toAmount: toAmount ?? this.toAmount,
      priceRate: priceRate ?? this.priceRate,
      networkFee: networkFee ?? this.networkFee,
      priceImpact: priceImpact ?? this.priceImpact,
      minimumReceived: minimumReceived ?? this.minimumReceived,
      route: route ?? this.route,
      recentSwaps: recentSwaps ?? this.recentSwaps,
    );
  }

  @override
  String toString() {
    return 'SwapState{isLoading: $isLoading, error: $error, fromAsset: ${fromAsset?['symbol']}, toAsset: ${toAsset?['symbol']}}';
  }
}

