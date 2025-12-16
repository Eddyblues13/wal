import 'dart:convert';
import 'package:wal/common/entities/entities.dart';
import '../utils/http_util.dart';

class UserAPI {
  // Login API - Updated to handle wallet and mnemonic response
  static Future<UserLoginResponseEntity> login({
    LoginRequestEntity? params,
  }) async {
    try {
      print('🔐 Sending login request to PHP API...');
      print('📤 Request data: ${params?.toJson()}');

      var response = await HttpUtil().post(
        'login.php',
        mydata: params?.toJson(),
      );

      print('📥 Raw API response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed string to JSON');
        } catch (e) {
          print('❌ Failed to parse string response: $e');
          return UserLoginResponseEntity(
            status: "error",
            report: "Invalid response format from server",
            wallet: "",
            mnemonic: "",
          );
        }
      } else {
        print('❌ Unexpected response format: ${response.runtimeType}');
        return UserLoginResponseEntity(
          status: "error",
          report: "Server returned unexpected format: ${response.runtimeType}",
          wallet: "",
          mnemonic: "",
        );
      }

      print('🔑 Response keys: ${responseData.keys}');
      print('📝 Status: ${responseData["Status"]}');
      print('📝 Report: ${responseData["Report"]}');
      print('👛 Wallet: ${responseData["wallet"]}');
      print('🔐 Mnemonic present: ${responseData["mnemonic"] != null}');

      return UserLoginResponseEntity.fromJson(responseData);
    } catch (e) {
      print('💥 Login API exception: $e');
      return UserLoginResponseEntity(
        status: "error",
        report: "Network error: ${e.toString()}",
        wallet: "",
        mnemonic: "",
      );
    }
  }

  // Register API - Updated to handle potential wallet response
  static Future<RegisterResponseEntity> register({
    RegisterRequestEntity? params,
  }) async {
    try {
      print('📝 Sending register request to PHP API...');
      print('📤 Request data: ${params?.toJson()}');

      var response = await HttpUtil().post(
        'register.php',
        mydata: params?.toJson(),
      );

      print('📥 Raw register response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed string to JSON');
        } catch (e) {
          print('❌ Failed to parse string response: $e');
          return RegisterResponseEntity(
            status: "error",
            report: "Invalid response format from server",
          );
        }
      } else {
        print('❌ Unexpected response format: ${response.runtimeType}');
        return RegisterResponseEntity(
          status: "error",
          report: "Server returned unexpected format: ${response.runtimeType}",
        );
      }

      print('🔑 Response keys: ${responseData.keys}');
      print('📝 Status: ${responseData["Status"]}');
      print('📝 Report: ${responseData["Report"]}');

      // Log wallet data if present in registration
      if (responseData.containsKey("wallet")) {
        print(
          '👛 Wallet provided during registration: ${responseData["wallet"]}',
        );
      }

      return RegisterResponseEntity.fromJson(responseData);
    } catch (e) {
      print('💥 Register API exception: $e');
      return RegisterResponseEntity(
        status: "error",
        report: "Network error: ${e.toString()}",
      );
    }
  }

  // Forgot Password API
  static Future<ForgotPasswordResponseEntity> forgotPassword({
    ForgotPasswordRequestEntity? params,
  }) async {
    try {
      print('🔑 Sending forgot password request to PHP API...');
      print('📤 Request data: ${params?.toJson()}');

      var response = await HttpUtil().post(
        'forgot_password.php',
        mydata: params?.toJson(),
      );

      print('📥 Raw forgot password response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed string to JSON');
        } catch (e) {
          print('❌ Failed to parse string response: $e');
          return ForgotPasswordResponseEntity(
            status: "error",
            report: "Invalid response format from server",
          );
        }
      } else {
        print('❌ Unexpected response format: ${response.runtimeType}');
        return ForgotPasswordResponseEntity(
          status: "error",
          report: "Server returned unexpected format: ${response.runtimeType}",
        );
      }

      print('🔑 Response keys: ${responseData.keys}');
      print('📝 Status: ${responseData["Status"]}');
      print('📝 Report: ${responseData["Report"]}');

      return ForgotPasswordResponseEntity.fromJson(responseData);
    } catch (e) {
      print('💥 Forgot password API exception: $e');
      return ForgotPasswordResponseEntity(
        status: "error",
        report: "Network error: ${e.toString()}",
      );
    }
  }

  // NEW: Get User Profile API (if your backend supports it)
  static Future<UserItem> getUserProfile() async {
    try {
      print('👤 Fetching user profile...');

      var response = await HttpUtil().get('profile.php');

      print('📥 Raw profile response: $response');
      print('📊 Response type: ${response.runtimeType}');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse profile response: $e');
          throw Exception('Invalid profile response format');
        }
      } else {
        throw Exception('Unexpected profile response format');
      }

      // Handle different response formats
      if (responseData.containsKey("data")) {
        return UserItem.fromJson(responseData["data"]);
      } else {
        return UserItem.fromJson(responseData);
      }
    } catch (e) {
      print('💥 Get profile API exception: $e');
      rethrow;
    }
  }

  // NEW: Update User Profile API
  static Future<ApiResponseEntity<UserItem>> updateProfile({
    required UserItem user,
  }) async {
    try {
      print('✏️ Updating user profile...');
      print('📤 Profile data: ${user.toJson()}');

      var response = await HttpUtil().post(
        'update_profile.php',
        mydata: user.toJson(),
      );

      print('📥 Raw update profile response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse update profile response: $e');
          return ApiResponseEntity(
            success: false,
            message: "Invalid response format",
            error: e.toString(),
          );
        }
      } else {
        return ApiResponseEntity(
          success: false,
          message: "Unexpected response format",
          error: "Format: ${response.runtimeType}",
        );
      }

      return ApiResponseEntity.fromJson(
        responseData,
        (data) => UserItem.fromJson(data),
      );
    } catch (e) {
      print('💥 Update profile API exception: $e');
      return ApiResponseEntity(
        success: false,
        message: "Network error",
        error: e.toString(),
      );
    }
  }

  // NEW: Wallet Operations API
  static Future<ApiResponseEntity<WalletEntity>> getWalletInfo() async {
    try {
      print('👛 Fetching wallet information...');

      var response = await HttpUtil().get('wallet_info.php');

      print('📥 Raw wallet response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse wallet response: $e');
          return ApiResponseEntity(
            success: false,
            message: "Invalid wallet response format",
            error: e.toString(),
          );
        }
      } else {
        return ApiResponseEntity(
          success: false,
          message: "Unexpected wallet response format",
          error: "Format: ${response.runtimeType}",
        );
      }

      return ApiResponseEntity.fromJson(
        responseData,
        (data) => WalletEntity.fromJson(data),
      );
    } catch (e) {
      print('💥 Get wallet API exception: $e');
      return ApiResponseEntity(
        success: false,
        message: "Network error while fetching wallet",
        error: e.toString(),
      );
    }
  }

  // NEW: Backup Mnemonic API
  static Future<ApiResponseEntity<void>> backupMnemonic() async {
    try {
      print('💾 Backing up mnemonic phrase...');

      var response = await HttpUtil().post('backup_mnemonic.php', mydata: {});

      print('📥 Raw backup response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse backup response: $e');
          return ApiResponseEntity(
            success: false,
            message: "Invalid backup response format",
            error: e.toString(),
          );
        }
      } else {
        return ApiResponseEntity(
          success: false,
          message: "Unexpected backup response format",
          error: "Format: ${response.runtimeType}",
        );
      }

      return ApiResponseEntity.fromJson(responseData, null);
    } catch (e) {
      print('💥 Backup mnemonic API exception: $e');
      return ApiResponseEntity(
        success: false,
        message: "Network error during backup",
        error: e.toString(),
      );
    }
  }

  // NEW: Validate Mnemonic API
  static Future<ApiResponseEntity<bool>> validateMnemonic(
    String mnemonic,
  ) async {
    try {
      print('🔍 Validating mnemonic phrase...');

      var response = await HttpUtil().post(
        'validate_mnemonic.php',
        mydata: {"mnemonic": mnemonic},
      );

      print('📥 Raw validation response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse validation response: $e');
          return ApiResponseEntity(
            success: false,
            message: "Invalid validation response format",
            error: e.toString(),
          );
        }
      } else {
        return ApiResponseEntity(
          success: false,
          message: "Unexpected validation response format",
          error: "Format: ${response.runtimeType}",
        );
      }

      return ApiResponseEntity.fromJson(
        responseData,
        (data) => data["is_valid"] ?? false,
      );
    } catch (e) {
      print('💥 Validate mnemonic API exception: $e');
      return ApiResponseEntity(
        success: false,
        message: "Network error during validation",
        error: e.toString(),
      );
    }
  }

  // NEW: Logout API
  static Future<ApiResponseEntity<void>> logout() async {
    try {
      print('🚪 Logging out...');

      var response = await HttpUtil().post('logout.php', mydata: {});

      print('📥 Raw logout response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse logout response: $e');
          return ApiResponseEntity(
            success: false,
            message: "Invalid logout response format",
            error: e.toString(),
          );
        }
      } else {
        return ApiResponseEntity(
          success: false,
          message: "Unexpected logout response format",
          error: "Format: ${response.runtimeType}",
        );
      }

      return ApiResponseEntity.fromJson(responseData, null);
    } catch (e) {
      print('💥 Logout API exception: $e');
      return ApiResponseEntity(
        success: false,
        message: "Network error during logout",
        error: e.toString(),
      );
    }
  }
}
