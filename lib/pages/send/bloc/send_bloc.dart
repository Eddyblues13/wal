// send_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/send/bloc/send_event.dart';
import 'package:wal/pages/send/bloc/send_state.dart';

// Internal event for setting assets
class _SetAssetsEvent extends SendEvent {
  final List<Map<String, dynamic>> assets;
  
  const _SetAssetsEvent(this.assets);
}

// Internal event for setting sending state
class _SetSendingEvent extends SendEvent {
  final bool isSending;
  
  const _SetSendingEvent(this.isSending);
}

class SendBloc extends Bloc<SendEvent, SendState> {
  SendBloc() : super(const SendState()) {
    on<LoadSendAssetsEvent>(_onLoadAssets);
    on<RefreshSendAssetsEvent>(_onRefreshAssets);
    on<SearchAssetsEvent>(_onSearchAssets);
    on<FilterNetworkEvent>(_onFilterNetwork);
    on<SelectAssetEvent>(_onSelectAsset);
    on<LoadingEvent>(_onLoadingChanged);
    on<ErrorEvent>(_onErrorOccurred);
    on<_SetAssetsEvent>(_onSetAssets);
    on<SendTransactionEvent>(_onSendTransaction);
    on<SendTransactionSuccessEvent>(_onSendTransactionSuccess);
    on<SendTransactionErrorEvent>(_onSendTransactionError);
    on<ResetSendTransactionEvent>(_onResetSendTransaction);
    on<_SetSendingEvent>(_onSetSending);
  }

  void _onSetAssets(
    _SetAssetsEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(
      assets: event.assets,
      filteredAssets: event.assets,
      isLoading: false,
      error: "",
    ));
  }

  void _onLoadAssets(
    LoadSendAssetsEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onRefreshAssets(
    RefreshSendAssetsEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onSearchAssets(
    SearchAssetsEvent event,
    Emitter<SendState> emit,
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
    Emitter<SendState> emit,
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
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(selectedAsset: event.asset));
  }

  void _onLoadingChanged(
    LoadingEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onErrorOccurred(
    ErrorEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(
      error: event.error,
      isLoading: false,
    ));
  }

  void _onSendTransaction(
    SendTransactionEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(
      isSending: true,
      sendSuccess: false,
      sendError: "",
      sendMessage: "",
    ));
  }

  void _onSendTransactionSuccess(
    SendTransactionSuccessEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(
      isSending: false,
      sendSuccess: true,
      sendMessage: event.message,
      sendError: "",
      transactionHash: event.transactionHash,
      sendCoinSymbol: event.coinSymbol,
      sendAmount: event.amount,
    ));
  }

  void _onSendTransactionError(
    SendTransactionErrorEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(
      isSending: false,
      sendSuccess: false,
      sendError: event.error,
      sendMessage: event.error,
    ));
  }

  void _onResetSendTransaction(
    ResetSendTransactionEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(
      isSending: false,
      sendSuccess: false,
      sendError: "",
      sendMessage: "",
      transactionHash: null,
      sendCoinSymbol: null,
      sendAmount: null,
    ));
  }

  void _onSetSending(
    _SetSendingEvent event,
    Emitter<SendState> emit,
  ) {
    emit(state.copyWith(
      isSending: event.isSending,
      sendSuccess: false,
      sendError: "",
      sendMessage: "",
    ));
  }

  // Public methods
  void setAssets(List<Map<String, dynamic>> assets) {
    add(_SetAssetsEvent(assets));
  }

  void setLoading(bool isLoading) {
    add(LoadingEvent(isLoading));
  }

  void setError(String error) {
    add(ErrorEvent(error));
  }

  void setSending(bool isSending) {
    add(_SetSendingEvent(isSending));
  }

  void setSendSuccess(
    String message, {
    String? transactionHash,
    String? coinSymbol,
    String? amount,
  }) {
    add(SendTransactionSuccessEvent(
      message,
      transactionHash: transactionHash,
      coinSymbol: coinSymbol,
      amount: amount,
    ));
  }

  void setSendError(String error) {
    add(SendTransactionErrorEvent(error));
  }

  void resetSendTransaction() {
    add(const ResetSendTransactionEvent());
  }
}

