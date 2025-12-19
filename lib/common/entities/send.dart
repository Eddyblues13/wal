// lib/common/entities/send.dart

// Send Transaction Request Entity
// Note: Wallet address is required - backend uses it to identify the user
class SendTransactionRequestEntity {
  final String wallet;
  final String receiverAddress;
  final String coinSymbol;
  final String amount;
  final String network;

  const SendTransactionRequestEntity({
    required this.wallet,
    required this.receiverAddress,
    required this.coinSymbol,
    required this.amount,
    required this.network,
  });

  Map<String, dynamic> toJson() => {
        "wallet": wallet,
        "receiver_address": receiverAddress,
        "coin_symbol": coinSymbol,
        "amount": amount,
        "network": network,
      };
}

// Send Transaction Response Entity
class SendTransactionResponseEntity {
  final bool success;
  final String message;
  final String? error;
  final String? transactionHash;

  SendTransactionResponseEntity({
    required this.success,
    required this.message,
    this.error,
    this.transactionHash,
  });

  factory SendTransactionResponseEntity.fromJson(Map<String, dynamic> json) =>
      SendTransactionResponseEntity(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        error: json["error"]?.toString(),
        transactionHash: json["transaction_hash"]?.toString(),
      );

  // Helper getter to check if successful
  bool get isSuccess => success;

  // For compatibility with existing code
  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        if (error != null) "error": error,
        if (transactionHash != null) "transaction_hash": transactionHash,
      };
}

