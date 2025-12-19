// send_event.dart
abstract class SendEvent {
  const SendEvent();
}

class LoadSendAssetsEvent extends SendEvent {
  final String walletAddress;
  const LoadSendAssetsEvent(this.walletAddress);
}

class RefreshSendAssetsEvent extends SendEvent {
  final String walletAddress;
  const RefreshSendAssetsEvent(this.walletAddress);
}

class SearchAssetsEvent extends SendEvent {
  final String query;
  const SearchAssetsEvent(this.query);
}

class FilterNetworkEvent extends SendEvent {
  final String? network;
  const FilterNetworkEvent(this.network);
}

class SelectAssetEvent extends SendEvent {
  final Map<String, dynamic> asset;
  const SelectAssetEvent(this.asset);
}

class LoadingEvent extends SendEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ErrorEvent extends SendEvent {
  final String error;
  const ErrorEvent(this.error);
}

class SendTransactionEvent extends SendEvent {
  final String walletAddress;
  final String receiverAddress;
  final String coinSymbol;
  final String amount;
  final String network;
  const SendTransactionEvent({
    required this.walletAddress,
    required this.receiverAddress,
    required this.coinSymbol,
    required this.amount,
    required this.network,
  });
}

class SendTransactionSuccessEvent extends SendEvent {
  final String message;
  final String? transactionHash;
  final String? coinSymbol;
  final String? amount;
  const SendTransactionSuccessEvent(
    this.message, {
    this.transactionHash,
    this.coinSymbol,
    this.amount,
  });
}

class SendTransactionErrorEvent extends SendEvent {
  final String error;
  const SendTransactionErrorEvent(this.error);
}

class ResetSendTransactionEvent extends SendEvent {
  const ResetSendTransactionEvent();
}

