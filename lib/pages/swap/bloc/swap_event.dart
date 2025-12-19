// swap_event.dart
abstract class SwapEvent {
  const SwapEvent();
}

class LoadSwapDataEvent extends SwapEvent {
  final String walletAddress;
  const LoadSwapDataEvent(this.walletAddress);
}

class RefreshSwapDataEvent extends SwapEvent {
  final String walletAddress;
  const RefreshSwapDataEvent(this.walletAddress);
}

class SelectFromAssetEvent extends SwapEvent {
  final Map<String, dynamic> asset;
  const SelectFromAssetEvent(this.asset);
}

class SelectToAssetEvent extends SwapEvent {
  final Map<String, dynamic> asset;
  const SelectToAssetEvent(this.asset);
}

class UpdateFromAmountEvent extends SwapEvent {
  final String amount;
  const UpdateFromAmountEvent(this.amount);
}

class UpdateToAmountEvent extends SwapEvent {
  final String amount;
  const UpdateToAmountEvent(this.amount);
}

class SwapTokensEvent extends SwapEvent {
  const SwapTokensEvent();
}

class LoadingEvent extends SwapEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ErrorEvent extends SwapEvent {
  final String error;
  const ErrorEvent(this.error);
}

