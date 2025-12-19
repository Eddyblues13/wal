// lib/common/apis/home_api.dart
import 'wallet_api.dart';
import 'history_api.dart';

class HomeAPI {
  // Get home data (wallet balance, assets, transactions, profile)
  static Future<Map<String, dynamic>> getHomeData(
    String walletAddress,
  ) async {
    try {
      print('🏠 Fetching home data for: $walletAddress');

      // Fetch wallet balance and assets
      final walletData = await WalletAPI.getWalletBalance(walletAddress);
      
      // Fetch transaction history
      final transactionData = await HistoryAPI.getTransactionHistory(walletAddress);

      // Check for errors
      if (walletData.containsKey('error')) {
        print('⚠️ Wallet API error, using default data');
        return _getDefaultHomeData(walletAddress);
      }

      // Parse wallet data
      final totalPortfolio =
          (walletData['total_portfolio_usdt'] as num?)?.toDouble() ?? 0.0;
      final assets =
          (walletData['assets'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      List<Map<String, dynamic>> cryptoAssets = _convertApiAssetsToAppFormat(assets);
      
      // Ensure the three default coins (USDT, STAR, TON) are always present
      cryptoAssets = _ensureDefaultThreeCoins(cryptoAssets);

      // Parse transaction data
      List<Map<String, dynamic>> recentTransactions = [];
      if (!transactionData.containsKey('error')) {
        recentTransactions =
            (transactionData['transactions'] as List?)
                ?.cast<Map<String, dynamic>>()
                .take(5)
                .toList() ??
            [];
      }

      // Get user profile (default for now)
      final userProfile = {
        'name': 'User',
        'email': 'user@example.com',
        'joinDate': '2023-01-15',
        'level': 'Member',
        'avatarUrl': '',
      };

      const referralCode = 'WALLET2024';

      return {
        'balance': totalPortfolio,
        'portfolioValue': totalPortfolio,
        'portfolioChange': 0.0,
        'cryptoAssets': cryptoAssets,
        'recentTransactions': recentTransactions,
        'userProfile': userProfile,
        'referralCode': referralCode,
      };
    } catch (e) {
      print('💥 Home data API exception: $e');
      print('🔄 Falling back to default data');
      return _getDefaultHomeData(walletAddress);
    }
  }

  // Default home data when API fails
  static Map<String, dynamic> _getDefaultHomeData(String walletAddress) {
    print('📋 Using default home data');
    
    final demoTransactions = [
      {
        'date': '25-11-03 11:54',
        'coin': 'Starcoin',
        'amount': 10.0,
        'hash': 'e4e3a315a7489160d25b80adbe566dcb92b711a30870fe5d1567f687d6dbc4fe',
        'explorer': 'https://tonviewer.com/transaction/e4e3a315a7489160d25b80adbe566dcb92b711a30870fe5d1567f687d6dbc4fe',
      },
      {
        'date': '25-11-03 11:51',
        'coin': 'TON',
        'amount': 0.5,
        'hash': 'a6b14e9331b23f1f0e42dc87b84c1d0706bc71fba7c9438cc021c8d6ae8e8690',
        'explorer': 'https://tonviewer.com/transaction/a6b14e9331b23f1f0e42dc87b84c1d0706bc71fba7c9438cc021c8d6ae8e8690',
      },
    ];

    return {
      'balance': 12560.75,
      'portfolioValue': 3560.25,
      'portfolioChange': 2.34,
      'cryptoAssets': _getDefaultThreeCoins(),
      'recentTransactions': demoTransactions,
      'userProfile': {
        'name': 'User',
        'email': 'user@example.com',
        'joinDate': '2023-01-15',
        'level': 'Member',
        'avatarUrl': '',
      },
      'referralCode': 'WALLET2024',
    };
  }

  // Ensure USDT, STAR, and TON are always in the assets list
  static List<Map<String, dynamic>> _ensureDefaultThreeCoins(
    List<Map<String, dynamic>> existingAssets,
  ) {
    final defaultSymbols = ['USDT', 'STAR', 'TON'];
    final Map<String, Map<String, dynamic>> assetsMap = {};
    
    // Add existing assets to map
    for (var asset in existingAssets) {
      final symbolStr = asset['symbol'] as String?;
      if (symbolStr != null) {
        final symbol = symbolStr.toUpperCase();
        assetsMap[symbol] = asset;
      }
    }
    
    // Ensure default three coins are present
    for (var symbol in defaultSymbols) {
      if (!assetsMap.containsKey(symbol)) {
        assetsMap[symbol] = _getDefaultCoinData(symbol);
      }
    }
    
    // Return assets in the order: USDT, STAR, TON, then others
    final List<Map<String, dynamic>> result = [];
    
    // Add default three coins first
    for (var symbol in defaultSymbols) {
      if (assetsMap.containsKey(symbol)) {
        result.add(assetsMap[symbol]!);
      }
    }
    
    // Add remaining assets
    for (var asset in existingAssets) {
      final symbolStr = asset['symbol'] as String?;
      if (symbolStr != null) {
        final symbol = symbolStr.toUpperCase();
        if (!defaultSymbols.contains(symbol)) {
          result.add(asset);
        }
      }
    }
    
    return result;
  }
  
  // Get default coin data for USDT, STAR, or TON
  static Map<String, dynamic> _getDefaultCoinData(String symbol) {
    final coinData = {
      'USDT': {
        'name': 'USDT',
        'amount': '0.00 USDT',
        'value': '\$0.00',
      },
      'STAR': {
        'name': 'STAR',
        'amount': '0.00 STAR',
        'value': '\$0.00',
      },
      'TON': {
        'name': 'Toncoin',
        'amount': '0.00 TON',
        'value': '\$0.00',
      },
    };
    
    final data = coinData[symbol.toUpperCase()] ?? {
      'name': symbol,
      'amount': '0.00 $symbol',
      'value': '\$0.00',
    };
    
    return {
      'symbol': symbol.toUpperCase(),
      'name': data['name'] as String,
      'amount': data['amount'] as String,
      'value': data['value'] as String,
      'change': '+0.00%',
      'network': 'TON',
      'balance': 0.0001, // Small balance to ensure they show up (passes > 0 filter)
    };
  }
  
  // Default three coins: USDT, STAR, TON (for default home data)
  static List<Map<String, dynamic>> _getDefaultThreeCoins() {
    return [
      _getDefaultCoinData('USDT'),
      _getDefaultCoinData('STAR'),
      _getDefaultCoinData('TON'),
    ];
  }

  // Helper: Convert API assets to app format
  static List<Map<String, dynamic>> _convertApiAssetsToAppFormat(
    List<Map<String, dynamic>> apiAssets,
  ) {
    if (apiAssets.isEmpty) {
      return [];
    }

    return apiAssets.map((asset) {
      final balance = (asset['balance'] as num?)?.toDouble() ?? 0.0;
      final price = (asset['price_usdt'] as num?)?.toDouble() ?? 0.0;
      final value = (asset['value_usdt'] as num?)?.toDouble() ?? 0.0;
      final change = price > 0
          ? ((value - (balance * price)) / (balance * price)) * 100
          : 0.0;

      final symbol = (asset['symbol'] ?? 'Unknown').toString().toUpperCase();
      
      // Normalize display names for USDT, STAR, and TON
      String displayName;
      if (symbol == 'USDT') {
        displayName = 'USDT';
      } else if (symbol == 'STAR') {
        displayName = 'STAR';
      } else if (symbol == 'TON') {
        displayName = 'Toncoin';
      } else {
        displayName = asset['name'] ?? symbol;
      }

      return {
        'symbol': symbol,
        'name': displayName,
        'amount': '${balance.toStringAsFixed(4)} $symbol',
        'value': '\$${value.toStringAsFixed(2)}',
        'change': '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
        'network': 'TON',
        'balance': balance,
        'price_usdt': price,
        'icon': asset['icon'],
        'contract': asset['contract'],
      };
    }).toList();
  }
}

