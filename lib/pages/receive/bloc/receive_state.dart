// receive_state.dart
class ReceiveState {
  const ReceiveState({
    this.isLoading = false,
    this.error = "",
    this.assets = const [],
    this.filteredAssets = const [],
    this.popularAssets = const [],
    this.searchQuery = "",
    this.selectedNetwork,
    this.selectedAsset,
  });

  final bool isLoading;
  final String error;
  final List<Map<String, dynamic>> assets;
  final List<Map<String, dynamic>> filteredAssets;
  final List<Map<String, dynamic>> popularAssets;
  final String searchQuery;
  final String? selectedNetwork;
  final Map<String, dynamic>? selectedAsset;

  ReceiveState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? assets,
    List<Map<String, dynamic>>? filteredAssets,
    List<Map<String, dynamic>>? popularAssets,
    String? searchQuery,
    String? selectedNetwork,
    Map<String, dynamic>? selectedAsset,
  }) {
    return ReceiveState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      assets: assets ?? this.assets,
      filteredAssets: filteredAssets ?? this.filteredAssets,
      popularAssets: popularAssets ?? this.popularAssets,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedNetwork: selectedNetwork ?? this.selectedNetwork,
      selectedAsset: selectedAsset ?? this.selectedAsset,
    );
  }

  @override
  String toString() {
    return 'ReceiveState{isLoading: $isLoading, error: $error, assets: ${assets.length}, filteredAssets: ${filteredAssets.length}}';
  }
}

