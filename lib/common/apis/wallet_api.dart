// lib/common/apis/wallet_api.dart
import 'dart:convert';
import '../utils/http_util.dart';

class WalletAPI {
  // Get wallet balance and assets
  static Future<Map<String, dynamic>> getWalletBalance(
    String walletAddress,
  ) async {
    try {
      print('💰 Fetching wallet balance for: $walletAddress');

      var response = await HttpUtil().post(
        'tonbalance.php',
        mydata: {
          'wallet': walletAddress, // Send wallet address as parameter
        },
      );

      print('📥 Raw wallet balance response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Wallet response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Wallet response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed wallet string to JSON');
        } catch (e) {
          print('❌ Failed to parse wallet response: $e');
          return {
            'error': 'Invalid response format from server',
            'wallet': walletAddress,
            'total_portfolio_usdt': 0.0,
            'assets': [],
          };
        }
      } else {
        print('❌ Unexpected wallet response format: ${response.runtimeType}');
        return {
          'error': 'Server returned unexpected format',
          'wallet': walletAddress,
          'total_portfolio_usdt': 0.0,
          'assets': [],
        };
      }

      print('🔑 Wallet response keys: ${responseData.keys}');
      print('💵 Total Portfolio: ${responseData["total_portfolio_usdt"]}');
      print(
        '📊 Assets count: ${(responseData["assets"] as List?)?.length ?? 0}',
      );

      return responseData;
    } catch (e) {
      print('💥 Wallet balance API exception: $e');
      return {
        'error': 'Network error: ${e.toString()}',
        'wallet': walletAddress,
        'total_portfolio_usdt': 0.0,
        'assets': [],
      };
    }
  }
}
