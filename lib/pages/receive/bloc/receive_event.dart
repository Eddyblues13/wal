// receive_event.dart
abstract class ReceiveEvent {
  const ReceiveEvent();
}

class LoadReceiveAssetsEvent extends ReceiveEvent {
  final String walletAddress;
  const LoadReceiveAssetsEvent(this.walletAddress);
}

class RefreshReceiveAssetsEvent extends ReceiveEvent {
  final String walletAddress;
  const RefreshReceiveAssetsEvent(this.walletAddress);
}

class SearchAssetsEvent extends ReceiveEvent {
  final String query;
  const SearchAssetsEvent(this.query);
}

class FilterNetworkEvent extends ReceiveEvent {
  final String? network;
  const FilterNetworkEvent(this.network);
}

class SelectAssetEvent extends ReceiveEvent {
  final Map<String, dynamic> asset;
  const SelectAssetEvent(this.asset);
}

class LoadingEvent extends ReceiveEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ErrorEvent extends ReceiveEvent {
  final String error;
  const ErrorEvent(this.error);
}

