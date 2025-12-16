class HistoryState {
  const HistoryState({
    this.isLoading = false,
    this.selectedNetwork = 'All Networks',
    this.transactions = const [],
    this.transactionCount = 0,
    this.walletAddress = '',
    this.error = '',
  });

  final bool isLoading;
  final String selectedNetwork;
  final List<Map<String, dynamic>> transactions;
  final int transactionCount;
  final String walletAddress;
  final String error;

  HistoryState copyWith({
    bool? isLoading,
    String? selectedNetwork,
    List<Map<String, dynamic>>? transactions,
    int? transactionCount,
    String? walletAddress,
    String? error,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
      transactions: transactions ?? this.transactions,
      transactionCount: transactionCount ?? this.transactionCount,
      walletAddress: walletAddress ?? this.walletAddress,
      error: error ?? this.error,
    );
  }
}
