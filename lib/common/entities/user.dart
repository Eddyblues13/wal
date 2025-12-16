class LoginRequestEntity {
  final String username;
  final String password;

  const LoginRequestEntity({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}

// UPDATED: Login Response Entity for your PHP API with wallet and mnemonic
class UserLoginResponseEntity {
  final String status; // "success" or "error" from your API
  final String report; // Message from server
  final String wallet; // Wallet address from API
  final String mnemonic; // Mnemonic phrase from API

  UserLoginResponseEntity({
    required this.status,
    required this.report,
    required this.wallet,
    required this.mnemonic,
  });

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        status: json["Status"] ?? "error", // Capital 'S' from your API
        report: json["Report"] ?? "", // Capital 'R' from your API
        wallet: json["wallet"] ?? "", // Wallet address
        mnemonic: json["mnemonic"] ?? "", // Mnemonic phrase
      );

  // Helper getter to check if successful - handles typo "succcess" in your API
  bool get isSuccess =>
      status.toLowerCase() == "success" ||
      status.toLowerCase() == "succcess"; // Handle the typo in your API

  // For compatibility with existing code
  int? get code => isSuccess ? 200 : 400;
  String? get msg => report;
}

// UPDATED: Register Request Entity for your PHP API
class RegisterRequestEntity {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterRequestEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "password": password,
    "first_name": firstName,
    "last_name": lastName,
  };
}

// UPDATED: Register Response Entity for your PHP API
class RegisterResponseEntity {
  final String status; // "success" or "error" from your API
  final String report; // Message from server
  final Map<String, dynamic>? data;
  final String? wallet; // Optional wallet for registration
  final String? mnemonic; // Optional mnemonic for registration

  RegisterResponseEntity({
    required this.status,
    required this.report,
    this.data,
    this.wallet,
    this.mnemonic,
  });

  factory RegisterResponseEntity.fromJson(Map<String, dynamic> json) =>
      RegisterResponseEntity(
        status: json["Status"] ?? "error", // Capital 'S' from your API
        report: json["Report"] ?? "", // Capital 'R' from your API
        data: json["data"],
        wallet: json["wallet"], // Wallet if provided during registration
        mnemonic: json["mnemonic"], // Mnemonic if provided during registration
      );

  // Helper getter to check if successful - handles typo "succcess" in your API
  bool get isSuccess =>
      status.toLowerCase() == "success" ||
      status.toLowerCase() == "succcess"; // Handle the typo in your API

  // For compatibility with existing code
  int? get code => isSuccess ? 200 : 400;
  String? get msg => report;
}

// UPDATED: Forgot Password Request Entity for your PHP API
class ForgotPasswordRequestEntity {
  final String email;

  ForgotPasswordRequestEntity({required this.email});

  Map<String, dynamic> toJson() => {"email": email};
}

// UPDATED: Forgot Password Response Entity for your PHP API
class ForgotPasswordResponseEntity {
  final String status; // "success" or "error" from your API
  final String report; // Message from server
  final dynamic data;

  ForgotPasswordResponseEntity({
    required this.status,
    required this.report,
    this.data,
  });

  factory ForgotPasswordResponseEntity.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponseEntity(
        status: json["Status"] ?? "error", // Capital 'S' from your API
        report: json["Report"] ?? "", // Capital 'R' from your API
        data: json["data"],
      );

  // Helper getter to check if successful - handles typo "succcess" in your API
  bool get isSuccess =>
      status.toLowerCase() == "success" ||
      status.toLowerCase() == "succcess"; // Handle the typo in your API

  // For compatibility with existing code
  int? get code => isSuccess ? 200 : 400;
  String? get msg => report;
}

// UPDATED: User Data Model with wallet support
class UserItem {
  final String? token;
  final String? username;
  final String? email;
  final String? wallet; // Added wallet field
  final String? mnemonic; // Added mnemonic field
  final DateTime? loginTime;

  UserItem({
    this.token,
    this.username,
    this.email,
    this.wallet,
    this.mnemonic,
    this.loginTime,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
    token: json["token"],
    username: json["username"],
    email: json["email"],
    wallet: json["wallet"],
    mnemonic: json["mnemonic"],
    loginTime: json["login_time"] != null
        ? DateTime.parse(json["login_time"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "username": username,
    "email": email,
    "wallet": wallet,
    "mnemonic": mnemonic,
    "login_time": loginTime?.toIso8601String(),
  };

  // Helper method to check if user has wallet data
  bool get hasWallet => wallet != null && wallet!.isNotEmpty;

  // Helper method to get shortened wallet address for display
  String get displayWallet {
    if (wallet == null || wallet!.isEmpty) return "No Wallet";
    if (wallet!.length <= 12) return wallet!;
    return "${wallet!.substring(0, 6)}...${wallet!.substring(wallet!.length - 6)}";
  }
}

// NEW: Wallet-specific entity for handling wallet operations
class WalletEntity {
  final String address;
  final String mnemonic;
  final DateTime? createdAt;
  final bool isBackedUp;

  WalletEntity({
    required this.address,
    required this.mnemonic,
    this.createdAt,
    this.isBackedUp = false,
  });

  factory WalletEntity.fromJson(Map<String, dynamic> json) => WalletEntity(
    address: json["address"] ?? "",
    mnemonic: json["mnemonic"] ?? "",
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    isBackedUp: json["is_backed_up"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "mnemonic": mnemonic,
    "created_at": createdAt?.toIso8601String(),
    "is_backed_up": isBackedUp,
  };

  // Helper method to get shortened address for display
  String get displayAddress {
    if (address.length <= 12) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 6)}";
  }

  // Security: Method to get masked mnemonic for display
  String get maskedMnemonic {
    if (mnemonic.isEmpty) return "";
    final words = mnemonic.split(' ');
    if (words.length <= 2) return "•••";

    final masked = List<String>.filled(words.length, '•••');
    masked[0] = words[0];
    masked[words.length - 1] = words[words.length - 1];

    return masked.join(' ');
  }
}

// NEW: API Response wrapper for consistent response handling
class ApiResponseEntity<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final String? error;

  ApiResponseEntity({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.error,
  });

  factory ApiResponseEntity.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    T? data;
    if (fromJsonT != null && json['data'] != null) {
      data = fromJsonT(json['data']);
    }

    return ApiResponseEntity(
      success:
          (json["Status"] ?? "error").toString().toLowerCase() == "success",
      message: json["Report"] ?? "",
      data: data,
      statusCode: json["status_code"],
      error: json["error"],
    );
  }
}
