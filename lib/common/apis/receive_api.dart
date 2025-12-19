// lib/common/apis/receive_api.dart
import 'dart:convert';
import '../utils/http_util.dart';

class ReceiveAPI {
  // Get receive addresses for all supported assets
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<List<Map<String, dynamic>>> getReceiveAddresses(
    String walletAddress,
  ) async {
    try {
      print('📥 Fetching receive addresses for wallet: $walletAddress');

      var response = await HttpUtil().post(
        'receive_addresses.php',
        mydata: {'wallet': walletAddress},
      );

      print('📥 Raw receive addresses response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Receive response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Receive response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed receive string to JSON');
        } catch (e) {
          print('❌ Failed to parse receive response: $e');
          return _getDefaultReceiveAddresses();
        }
      } else {
        print('❌ Unexpected receive response format: ${response.runtimeType}');
        return _getDefaultReceiveAddresses();
      }

      // Check if response has error
      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultReceiveAddresses();
      }

      // Parse assets from response
      List<Map<String, dynamic>> assets = [];
      if (responseData.containsKey('assets') &&
          responseData['assets'] is List) {
        assets = List<Map<String, dynamic>>.from(responseData['assets']);
        print('✅ Successfully parsed ${assets.length} assets from API');
      } else {
        print('⚠️ No assets in response, using default data');
        return _getDefaultReceiveAddresses();
      }

      return assets;
    } catch (e) {
      print('💥 Receive addresses API exception: $e');
      print('🔄 Falling back to default data');
      return _getDefaultReceiveAddresses();
    }
  }

  // Default receive addresses when API fails - Only TON network coins
  static List<Map<String, dynamic>> _getDefaultReceiveAddresses() {
    print('📋 Using default receive addresses (TON network only)');

    return [
      {
        'symbol': 'TON',
        'name': 'Toncoin',
        'network': 'TON',
        'address': 'EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx',
        'logo': 'assets/images/ton.png',
      },
      {
        'symbol': 'USDT',
        'name': 'Tether USD',
        'network': 'TON',
        'address': 'EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx',
        'logo': 'assets/images/usdt.png',
      },
      {
        'symbol': 'STARCOIN',
        'name': 'STAR',
        'network': 'TON',
        'address': 'EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx',
        'logo': 'assets/images/starcoin.png',
      },
    ];
  }
}
