// lib/common/apis/swap_api.dart
import 'dart:convert';
import '../utils/http_util.dart';

class SwapAPI {
  // Get swap data (available assets, rates, etc.)
  static Future<Map<String, dynamic>> getSwapData(
    String walletAddress,
  ) async {
    try {
      print('🔄 Fetching swap data for: $walletAddress');

      var response = await HttpUtil().post(
        'swap_data.php',
        mydata: {
          'wallet': walletAddress,
        },
      );

      print('📥 Raw swap data response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Swap response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Swap response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed swap string to JSON');
        } catch (e) {
          print('❌ Failed to parse swap response: $e');
          return _getDefaultSwapData(walletAddress);
        }
      } else {
        print('❌ Unexpected swap response format: ${response.runtimeType}');
        return _getDefaultSwapData(walletAddress);
      }

      // Check if response has error
      if (responseData.containsKey('error') || responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultSwapData(walletAddress);
      }

      // Parse data from response
      List<Map<String, dynamic>> availableAssets = [];
      List<Map<String, dynamic>> recentSwaps = [];

      if (responseData.containsKey('assets') && responseData['assets'] is List) {
        availableAssets = List<Map<String, dynamic>>.from(responseData['assets']);
        print('✅ Successfully parsed ${availableAssets.length} assets from API');
      } else {
        print('⚠️ No assets in response, using default data');
        return _getDefaultSwapData(walletAddress);
      }

      if (responseData.containsKey('recentSwaps') && responseData['recentSwaps'] is List) {
        recentSwaps = List<Map<String, dynamic>>.from(responseData['recentSwaps']);
        print('✅ Successfully parsed ${recentSwaps.length} recent swaps from API');
      }

      return {
        'availableAssets': availableAssets,
        'recentSwaps': recentSwaps,
      };
    } catch (e) {
      print('💥 Swap data API exception: $e');
      print('🔄 Falling back to default data');
      return _getDefaultSwapData(walletAddress);
    }
  }

  // Default swap data when API fails
  static Map<String, dynamic> _getDefaultSwapData(String walletAddress) {
    print('📋 Using default swap data');
    
    return {
      'availableAssets': [
        {
          'symbol': 'STAR',
          'name': 'STAR',
          'network': 'BEP20',
          'balance': 1000.0,
        },
        {
          'symbol': 'USDT',
          'name': 'Tether USD',
          'network': 'TRC20',
          'balance': 250.0,
        },
        {
          'symbol': 'TON',
          'name': 'Toncoin',
          'network': 'TON Network',
          'balance': 35.0,
        },
      ],
      'recentSwaps': [
        {'from': 'STAR', 'to': 'USDT', 'amount': '100', 'value': '\$17.00', 'time': '10 mins ago'},
        {'from': 'TON', 'to': 'USDT', 'amount': '5', 'value': '\$25.00', 'time': '20 mins ago'},
        {'from': 'USDT', 'to': 'STAR', 'amount': '50', 'value': '\$8.50', 'time': '30 mins ago'},
      ],
    };
  }
}

