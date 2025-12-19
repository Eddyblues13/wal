// swap_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/swap/bloc/swap_event.dart';
import 'package:wal/pages/swap/bloc/swap_state.dart';

// Internal event for setting swap data
class _SetSwapDataEvent extends SwapEvent {
  final List<Map<String, dynamic>> availableAssets;
  final List<Map<String, dynamic>> recentSwaps;
  
  const _SetSwapDataEvent(this.availableAssets, this.recentSwaps);
}

class SwapBloc extends Bloc<SwapEvent, SwapState> {
  SwapBloc() : super(const SwapState()) {
    on<LoadSwapDataEvent>(_onLoadSwapData);
    on<RefreshSwapDataEvent>(_onRefreshSwapData);
    on<SelectFromAssetEvent>(_onSelectFromAsset);
    on<SelectToAssetEvent>(_onSelectToAsset);
    on<UpdateFromAmountEvent>(_onUpdateFromAmount);
    on<UpdateToAmountEvent>(_onUpdateToAmount);
    on<SwapTokensEvent>(_onSwapTokens);
    on<LoadingEvent>(_onLoadingChanged);
    on<ErrorEvent>(_onErrorOccurred);
    on<_SetSwapDataEvent>(_onSetSwapData);
  }

  void _onSetSwapData(
    _SetSwapDataEvent event,
    Emitter<SwapState> emit,
  ) {
    emit(state.copyWith(
      availableAssets: event.availableAssets,
      recentSwaps: event.recentSwaps,
      isLoading: false,
      error: "",
    ));
  }

  void _onLoadSwapData(
    LoadSwapDataEvent event,
    Emitter<SwapState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onRefreshSwapData(
    RefreshSwapDataEvent event,
    Emitter<SwapState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onSelectFromAsset(
    SelectFromAssetEvent event,
    Emitter<SwapState> emit,
  ) {
    final fromAsset = event.asset;
    final toAsset = state.toAsset;
    
    // If same asset selected, swap them
    if (toAsset != null && fromAsset['symbol'] == toAsset['symbol']) {
      emit(state.copyWith(
        fromAsset: toAsset,
        toAsset: fromAsset,
      ));
    } else {
      emit(state.copyWith(fromAsset: fromAsset));
    }
    
    // Recalculate amounts if needed
    _recalculateAmounts(emit, fromAsset, toAsset ?? state.toAsset);
  }

  void _onSelectToAsset(
    SelectToAssetEvent event,
    Emitter<SwapState> emit,
  ) {
    final toAsset = event.asset;
    final fromAsset = state.fromAsset;
    
    // If same asset selected, swap them
    if (fromAsset != null && fromAsset['symbol'] == toAsset['symbol']) {
      emit(state.copyWith(
        fromAsset: toAsset,
        toAsset: fromAsset,
      ));
    } else {
      emit(state.copyWith(toAsset: toAsset));
    }
    
    // Recalculate amounts if needed
    _recalculateAmounts(emit, fromAsset ?? state.fromAsset, toAsset);
  }

  void _onUpdateFromAmount(
    UpdateFromAmountEvent event,
    Emitter<SwapState> emit,
  ) {
    // Always set amounts to 0
    emit(state.copyWith(
      fromAmount: "0.00",
      toAmount: "0.00",
    ));
  }

  void _onUpdateToAmount(
    UpdateToAmountEvent event,
    Emitter<SwapState> emit,
  ) {
    final toAmount = event.amount;
    emit(state.copyWith(toAmount: toAmount));
    
    // Always set from amount to 0
    emit(state.copyWith(fromAmount: "0.00"));
  }

  void _onSwapTokens(
    SwapTokensEvent event,
    Emitter<SwapState> emit,
  ) {
    // Swap from and to assets
    final fromAsset = state.fromAsset;
    final toAsset = state.toAsset;
    final fromAmount = state.fromAmount;
    final toAmount = state.toAmount;
    
    if (fromAsset != null && toAsset != null) {
      emit(state.copyWith(
        fromAsset: toAsset,
        toAsset: fromAsset,
        fromAmount: toAmount,
        toAmount: fromAmount,
      ));
    }
  }

  void _onLoadingChanged(
    LoadingEvent event,
    Emitter<SwapState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onErrorOccurred(
    ErrorEvent event,
    Emitter<SwapState> emit,
  ) {
    emit(state.copyWith(
      error: event.error,
      isLoading: false,
    ));
  }

  void _recalculateAmounts(
    Emitter<SwapState> emit,
    Map<String, dynamic>? fromAsset,
    Map<String, dynamic>? toAsset,
  ) {
    // Always set amounts to 0
    emit(state.copyWith(
      fromAmount: "0.00",
      toAmount: "0.00",
    ));
  }

  // Public methods
  void setSwapData(
    List<Map<String, dynamic>> availableAssets,
    List<Map<String, dynamic>> recentSwaps,
  ) {
    add(_SetSwapDataEvent(availableAssets, recentSwaps));
  }

  void setLoading(bool isLoading) {
    add(LoadingEvent(isLoading));
  }

  void setError(String error) {
    add(ErrorEvent(error));
  }
}
