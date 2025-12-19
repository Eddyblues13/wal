// receive_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/receive/bloc/receive_event.dart';
import 'package:wal/pages/receive/bloc/receive_state.dart';

// Internal event for setting assets
class _SetAssetsEvent extends ReceiveEvent {
  final List<Map<String, dynamic>> assets;
  final List<Map<String, dynamic>> popularAssets;
  
  const _SetAssetsEvent(this.assets, this.popularAssets);
}

class ReceiveBloc extends Bloc<ReceiveEvent, ReceiveState> {
  ReceiveBloc() : super(const ReceiveState()) {
    on<LoadReceiveAssetsEvent>(_onLoadAssets);
    on<RefreshReceiveAssetsEvent>(_onRefreshAssets);
    on<SearchAssetsEvent>(_onSearchAssets);
    on<FilterNetworkEvent>(_onFilterNetwork);
    on<SelectAssetEvent>(_onSelectAsset);
    on<LoadingEvent>(_onLoadingChanged);
    on<ErrorEvent>(_onErrorOccurred);
    on<_SetAssetsEvent>(_onSetAssets);
  }

  void _onSetAssets(
    _SetAssetsEvent event,
    Emitter<ReceiveState> emit,
  ) {
    emit(state.copyWith(
      assets: event.assets,
      filteredAssets: event.assets,
      popularAssets: event.popularAssets,
      isLoading: false,
      error: "",
    ));
  }

  void _onLoadAssets(
    LoadReceiveAssetsEvent event,
    Emitter<ReceiveState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onRefreshAssets(
    RefreshReceiveAssetsEvent event,
    Emitter<ReceiveState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onSearchAssets(
    SearchAssetsEvent event,
    Emitter<ReceiveState> emit,
  ) {
    final query = event.query.toLowerCase();
    final filtered = state.assets.where((asset) {
      final symbol = (asset['symbol'] ?? '').toString().toLowerCase();
      final name = (asset['name'] ?? '').toString().toLowerCase();
      final network = (asset['network'] ?? '').toString().toLowerCase();
      return symbol.contains(query) ||
          name.contains(query) ||
          network.contains(query);
    }).toList();

    emit(state.copyWith(
      searchQuery: event.query,
      filteredAssets: filtered,
    ));
  }

  void _onFilterNetwork(
    FilterNetworkEvent event,
    Emitter<ReceiveState> emit,
  ) {
    final network = event.network;
    if (network == null || network.isEmpty) {
      emit(state.copyWith(
        selectedNetwork: null,
        filteredAssets: state.assets,
      ));
    } else {
      final filtered = state.assets
          .where((asset) => asset['network'] == network)
          .toList();
      emit(state.copyWith(
        selectedNetwork: network,
        filteredAssets: filtered,
      ));
    }
  }

  void _onSelectAsset(
    SelectAssetEvent event,
    Emitter<ReceiveState> emit,
  ) {
    emit(state.copyWith(selectedAsset: event.asset));
  }

  void _onLoadingChanged(
    LoadingEvent event,
    Emitter<ReceiveState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onErrorOccurred(
    ErrorEvent event,
    Emitter<ReceiveState> emit,
  ) {
    emit(state.copyWith(
      error: event.error,
      isLoading: false,
    ));
  }

  // Public methods
  void setAssets(List<Map<String, dynamic>> assets) {
    final popular = assets.take(2).toList();
    add(_SetAssetsEvent(assets, popular));
  }

  void setLoading(bool isLoading) {
    add(LoadingEvent(isLoading));
  }

  void setError(String error) {
    add(ErrorEvent(error));
  }
}
