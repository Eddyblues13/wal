// lib/common/entities/password.dart

// Update Password Request Entity
// Note: Wallet address is required - backend uses it to identify the user
class UpdatePasswordRequestEntity {
  final String wallet;
  final String oldPassword;
  final String newPassword;

  const UpdatePasswordRequestEntity({
    required this.wallet,
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    "wallet": wallet,
    "old_password": oldPassword,
    "new_password": newPassword,
  };
}

// Update Password Response Entity
class UpdatePasswordResponseEntity {
  final bool success;
  final String message;
  final String? error;

  UpdatePasswordResponseEntity({
    required this.success,
    required this.message,
    this.error,
  });

  factory UpdatePasswordResponseEntity.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordResponseEntity(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        error: json["error"]?.toString(),
      );

  // Helper getter to check if successful
  bool get isSuccess => success;

  // For compatibility with existing code
  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    if (error != null) "error": error,
  };
}

