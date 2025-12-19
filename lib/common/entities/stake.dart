// lib/common/entities/stake.dart

// Stake Request Entity
// Note: Wallet address is required - backend uses it to identify the user
class StakeRequestEntity {
  final String wallet;
  final String amount;
  final String coinSymbol;

  const StakeRequestEntity({
    required this.wallet,
    required this.amount,
    required this.coinSymbol,
  });

  Map<String, dynamic> toJson() => {
        "wallet": wallet,
        "amount": amount,
        "coin_symbol": coinSymbol,
      };
}

// Stake Response Entity
class StakeResponseEntity {
  final bool success;
  final String message;
  final String? error;
  final String? transactionHash;

  StakeResponseEntity({
    required this.success,
    required this.message,
    this.error,
    this.transactionHash,
  });

  factory StakeResponseEntity.fromJson(Map<String, dynamic> json) =>
      StakeResponseEntity(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        error: json["error"]?.toString(),
        transactionHash: json["transaction_hash"]?.toString(),
      );

  bool get isSuccess => success;
}

// Claim Rewards Request Entity
// Note: Wallet address is required - backend uses it to identify the user
class ClaimRewardsRequestEntity {
  final String wallet;
  final String? positionId; // Optional: if null, claim all

  const ClaimRewardsRequestEntity({
    required this.wallet,
    this.positionId,
  });

  Map<String, dynamic> toJson() => {
        "wallet": wallet,
        if (positionId != null) "position_id": positionId,
      };
}

// Claim Rewards Response Entity
class ClaimRewardsResponseEntity {
  final bool success;
  final String message;
  final String? error;
  final String? claimedAmount;
  final String? transactionHash;

  ClaimRewardsResponseEntity({
    required this.success,
    required this.message,
    this.error,
    this.claimedAmount,
    this.transactionHash,
  });

  factory ClaimRewardsResponseEntity.fromJson(Map<String, dynamic> json) =>
      ClaimRewardsResponseEntity(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        error: json["error"]?.toString(),
        claimedAmount: json["claimed_amount"]?.toString(),
        transactionHash: json["transaction_hash"]?.toString(),
      );

  bool get isSuccess => success;
}

// Daily Return Response Entity
class DailyReturnResponseEntity {
  final bool success;
  final String dailyReturn;
  final String? error;

  DailyReturnResponseEntity({
    required this.success,
    required this.dailyReturn,
    this.error,
  });

  factory DailyReturnResponseEntity.fromJson(Map<String, dynamic> json) =>
      DailyReturnResponseEntity(
        success: json["success"] ?? false,
        dailyReturn: json["daily_return"]?.toString() ?? "0.00",
        error: json["error"]?.toString(),
      );

  bool get isSuccess => success;
}

// Reward Tier Entity
class RewardTierEntity {
  final String minAmount;
  final String maxAmount;
  final String dailyReward;
  final String apr;

  RewardTierEntity({
    required this.minAmount,
    required this.maxAmount,
    required this.dailyReward,
    required this.apr,
  });

  factory RewardTierEntity.fromJson(Map<String, dynamic> json) =>
      RewardTierEntity(
        minAmount: json["min_amount"]?.toString() ?? "0",
        maxAmount: json["max_amount"]?.toString() ?? "0",
        dailyReward: json["daily_reward"]?.toString() ?? "0.00",
        apr: json["apr"]?.toString() ?? "0.00",
      );

  Map<String, dynamic> toJson() => {
        "min_amount": minAmount,
        "max_amount": maxAmount,
        "daily_reward": dailyReward,
        "apr": apr,
      };
}

// Reward Tiers Response Entity
class RewardTiersResponseEntity {
  final bool success;
  final List<RewardTierEntity> tiers;
  final String? error;

  RewardTiersResponseEntity({
    required this.success,
    required this.tiers,
    this.error,
  });

  factory RewardTiersResponseEntity.fromJson(Map<String, dynamic> json) {
    List<RewardTierEntity> tiersList = [];
    if (json["tiers"] is List) {
      tiersList = (json["tiers"] as List)
          .map((tier) => RewardTierEntity.fromJson(tier as Map<String, dynamic>))
          .toList();
    }
    return RewardTiersResponseEntity(
      success: json["success"] ?? false,
      tiers: tiersList,
      error: json["error"]?.toString(),
    );
  }

  bool get isSuccess => success;
}

