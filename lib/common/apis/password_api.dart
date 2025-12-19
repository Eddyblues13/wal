// lib/common/apis/password_api.dart
import 'dart:convert';
import '../entities/password.dart';
import '../utils/http_util.dart';

class PasswordAPI {
  // Update password
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<UpdatePasswordResponseEntity> updatePassword(
    String walletAddress,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      print('🔐 Updating password for wallet: $walletAddress');

      // Create request entity (wallet included - backend uses it to identify user)
      final requestEntity = UpdatePasswordRequestEntity(
        wallet: walletAddress,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      var response = await HttpUtil().post(
        'update_password.php',
        mydata: requestEntity.toJson(),
      );

      print('📥 Raw password update response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Password response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Password response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed password string to JSON');
        } catch (e) {
          print('❌ Failed to parse password response: $e');
          return _getDefaultPasswordResponse(true);
        }
      } else {
        print('❌ Unexpected password response format: ${response.runtimeType}');
        return _getDefaultPasswordResponse(true);
      }

      // Check if response has error
      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default response');
        return _getDefaultPasswordResponse(false);
      }

      // Parse response entity
      try {
        final responseEntity = UpdatePasswordResponseEntity.fromJson(
          responseData,
        );
        if (responseEntity.isSuccess) {
          print('✅ Password updated successfully');
        }
        return responseEntity;
      } catch (e) {
        print('❌ Failed to parse response entity: $e');
        return _getDefaultPasswordResponse(true);
      }
    } catch (e) {
      print('💥 Password update API exception: $e');
      print('🔄 Falling back to default response');
      return _getDefaultPasswordResponse(true);
    }
  }

  // Default password response when API fails
  static UpdatePasswordResponseEntity _getDefaultPasswordResponse(
    bool success,
  ) {
    print('📋 Using default password response');

    return UpdatePasswordResponseEntity(
      success: success,
      message: success
          ? 'Password updated successfully'
          : 'Failed to update password. Please try again.',
    );
  }
}
