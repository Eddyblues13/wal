// send_state.dart
class SendState {
  const SendState({
    this.isLoading = false,
    this.error = "",
    this.assets = const [],
    this.filteredAssets = const [],
    this.searchQuery = "",
    this.selectedNetwork,
    this.selectedAsset,
    this.isSending = false,
    this.sendSuccess = false,
    this.sendError = "",
    this.sendMessage = "",
    this.transactionHash,
    this.sendCoinSymbol,
    this.sendAmount,
  });

  final bool isLoading;
  final String error;
  final List<Map<String, dynamic>> assets;
  final List<Map<String, dynamic>> filteredAssets;
  final String searchQuery;
  final String? selectedNetwork;
  final Map<String, dynamic>? selectedAsset;
  final bool isSending;
  final bool sendSuccess;
  final String sendError;
  final String sendMessage;
  final String? transactionHash;
  final String? sendCoinSymbol;
  final String? sendAmount;

  SendState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? assets,
    List<Map<String, dynamic>>? filteredAssets,
    String? searchQuery,
    String? selectedNetwork,
    Map<String, dynamic>? selectedAsset,
    bool? isSending,
    bool? sendSuccess,
    String? sendError,
    String? sendMessage,
    String? transactionHash,
    String? sendCoinSymbol,
    String? sendAmount,
  }) {
    return SendState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      assets: assets ?? this.assets,
      filteredAssets: filteredAssets ?? this.filteredAssets,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
      selectedAsset: selectedAsset ?? this.selectedAsset,
      isSending: isSending ?? this.isSending,
      sendSuccess: sendSuccess ?? this.sendSuccess,
      sendError: sendError ?? this.sendError,
      sendMessage: sendMessage ?? this.sendMessage,
      transactionHash: transactionHash ?? this.transactionHash,
      sendCoinSymbol: sendCoinSymbol ?? this.sendCoinSymbol,
      sendAmount: sendAmount ?? this.sendAmount,
    );
  }

  @override
  String toString() {
    return 'SendState{isLoading: $isLoading, error: $error, assets: ${assets.length}, filteredAssets: ${filteredAssets.length}, isSending: $isSending, sendSuccess: $sendSuccess}';
  }
}

