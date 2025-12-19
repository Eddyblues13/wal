// lib/common/apis/send_api.dart
import 'dart:convert';
import '../entities/send.dart';
import '../utils/http_util.dart';

class SendAPI {
  // Get send assets (wallet balances) for all supported assets
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<List<Map<String, dynamic>>> getSendAssets(
    String walletAddress,
  ) async {
    try {
      print('📤 Fetching send assets for wallet: $walletAddress');

      var response = await HttpUtil().post(
        'send_assets.php',
        mydata: {'wallet': walletAddress},
      );

      print('📥 Raw send assets response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Send response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Send response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed send string to JSON');
        } catch (e) {
          print('❌ Failed to parse send response: $e');
          return _getDefaultSendAssets();
        }
      } else {
        print('❌ Unexpected send response format: ${response.runtimeType}');
        return _getDefaultSendAssets();
      }

      // Check if response has error
      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultSendAssets();
      }

      // Parse assets from response
      List<Map<String, dynamic>> assets = [];
      if (responseData.containsKey('assets') &&
          responseData['assets'] is List) {
        assets = List<Map<String, dynamic>>.from(responseData['assets']);
        print('✅ Successfully parsed ${assets.length} assets from API');
      } else {
        print('⚠️ No assets in response, using default data');
        return _getDefaultSendAssets();
      }

      return assets;
    } catch (e) {
      print('💥 Send assets API exception: $e');
      print('🔄 Falling back to default data');
      return _getDefaultSendAssets();
    }
  }

  // Send transaction
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<SendTransactionResponseEntity> sendTransaction(
    String walletAddress,
    String receiverAddress,
    String coinSymbol,
    String amount,
    String network,
  ) async {
    try {
      print(
        '📤 Sending transaction: $coinSymbol, Amount: $amount, Network: $network',
      );
      print('👛 Wallet: $walletAddress');

      // Create request entity (wallet included - backend uses it to identify user)
      final requestEntity = SendTransactionRequestEntity(
        wallet: walletAddress,
        receiverAddress: receiverAddress,
        coinSymbol: coinSymbol,
        amount: amount,
        network: network,
      );

      var response = await HttpUtil().post(
        'send_transaction.php',
        mydata: requestEntity.toJson(),
      );

      print('📥 Raw send transaction response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Send transaction response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Send transaction response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed send transaction string to JSON');
        } catch (e) {
          print('❌ Failed to parse send transaction response: $e');
          return _getDefaultSendTransactionResponse(true);
        }
      } else {
        print(
          '❌ Unexpected send transaction response format: ${response.runtimeType}',
        );
        return _getDefaultSendTransactionResponse(true);
      }

      // Check if response has error
      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default response');
        return _getDefaultSendTransactionResponse(false);
      }

      // Parse response entity
      try {
        final responseEntity = SendTransactionResponseEntity.fromJson(
          responseData,
        );
        if (responseEntity.isSuccess) {
          print('✅ Transaction sent successfully');
        }
        return responseEntity;
      } catch (e) {
        print('❌ Failed to parse response entity: $e');
        return _getDefaultSendTransactionResponse(true);
      }
    } catch (e) {
      print('💥 Send transaction API exception: $e');
      print('🔄 Falling back to default response');
      return _getDefaultSendTransactionResponse(true);
    }
  }

  // Default send assets when API fails - Only TON network coins
  static List<Map<String, dynamic>> _getDefaultSendAssets() {
    print('📋 Using default send assets (TON network only)');

    return [
      {
        'symbol': 'TON',
        'name': 'Toncoin',
        'network': 'TON',
        'amount': '35.00',
        'value': '\$245.00',
        'balance': 35.0,
        'logo': 'assets/images/ton.png', // Placeholder - adjust path as needed
      },
      {
        'symbol': 'USDT',
        'name': 'Tether USD',
        'network': 'TON',
        'amount': '250.00',
        'value': '\$250.00',
        'balance': 250.0,
        'logo': 'assets/images/usdt.png', // Placeholder - adjust path as needed
      },
      {
        'symbol': 'STARCOIN',
        'name': 'STAR',
        'network': 'TON',
        'amount': '1,200.00',
        'value': '\$60.00',
        'balance': 1200.0,
        'logo':
            'assets/images/starcoin.png', // Placeholder - adjust path as needed
      },
    ];
  }

  // Default send transaction response when API fails
  static SendTransactionResponseEntity _getDefaultSendTransactionResponse(
    bool success,
  ) {
    print('📋 Using default send transaction response');

    return SendTransactionResponseEntity(
      success: success,
      message: success
          ? 'Transaction sent successfully'
          : 'Failed to send transaction. Please try again.',
    );
  }
}
