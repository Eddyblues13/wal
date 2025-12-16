import 'dart:convert';
import '../utils/http_util.dart';

class HistoryAPI {
  // Get transaction history for a wallet
  static Future<Map<String, dynamic>> getTransactionHistory(
    String walletAddress,
  ) async {
    try {
      print('📜 Fetching transaction history for: $walletAddress');

      var response = await HttpUtil().post(
        'tonhistory.php',
        mydata: {
          'wallet': walletAddress, // Send wallet address as parameter
        },
      );

      print('📥 Raw history response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ History response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 History response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed history string to JSON');
        } catch (e) {
          print('❌ Failed to parse history response: $e');
          return {
            'error': 'Invalid response format from server',
            'wallet': walletAddress,
            'transaction_count': 0,
            'transactions': [],
          };
        }
      } else {
        print('❌ Unexpected history response format: ${response.runtimeType}');
        return {
          'error': 'Server returned unexpected format',
          'wallet': walletAddress,
          'transaction_count': 0,
          'transactions': [],
        };
      }

      print('🔑 History response keys: ${responseData.keys}');
      print('📊 Transaction count: ${responseData["transaction_count"]}');
      print(
        '📝 Transactions: ${(responseData["transactions"] as List?)?.length ?? 0}',
      );

      return responseData;
    } catch (e) {
      print('💥 Transaction history API exception: $e');
      return {
        'error': 'Network error: ${e.toString()}',
        'wallet': walletAddress,
        'transaction_count': 0,
        'transactions': [],
      };
    }
  }
}
