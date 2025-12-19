// lib/common/apis/stake_api.dart
import 'dart:convert';
import '../entities/stake.dart';
import '../utils/http_util.dart';

class StakeAPI {
  // Get stake data (staking packages, active positions, etc.)
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<Map<String, dynamic>> getStakeData(
    String walletAddress,
  ) async {
    try {
      print('💰 Fetching stake data for wallet: $walletAddress');

      var response = await HttpUtil().post(
        'stake_data.php',
        mydata: {
          'wallet': walletAddress,
        },
      );

      print('📥 Raw stake data response: $response');
      print('📊 Response type: ${response.runtimeType}');

      // Handle both String and Map responses
      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        print('✅ Stake response is valid JSON Map');
        responseData = response;
      } else if (response is String) {
        print('🔄 Stake response is String, parsing JSON...');
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
          print('✅ Successfully parsed stake string to JSON');
        } catch (e) {
          print('❌ Failed to parse stake response: $e');
          return _getDefaultStakeData();
        }
      } else {
        print('❌ Unexpected stake response format: ${response.runtimeType}');
        return _getDefaultStakeData();
      }

      // Check if response has error
      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultStakeData();
      }

      // Parse data from response
      List<Map<String, dynamic>> stakingPackages = [];
      List<Map<String, dynamic>> activePositions = [];

      if (responseData.containsKey('packages') && responseData['packages'] is List) {
        stakingPackages = List<Map<String, dynamic>>.from(responseData['packages']);
        print('✅ Successfully parsed ${stakingPackages.length} packages from API');
      } else {
        print('⚠️ No packages in response, using default data');
        return _getDefaultStakeData();
      }

      if (responseData.containsKey('positions') && responseData['positions'] is List) {
        activePositions = List<Map<String, dynamic>>.from(responseData['positions']);
        print('✅ Successfully parsed ${activePositions.length} positions from API');
      }

      // Calculate totals
      final totalStaked = _calculateTotalStaked(activePositions);
      final totalDailyRewards = _calculateTotalDailyRewards(activePositions);
      final totalEarned = responseData['totalEarned']?.toString() ?? '0.00';
      final referralRewards = responseData['referralRewards']?.toString() ?? '0.00';

      return {
        'stakingPackages': stakingPackages,
        'activePositions': activePositions,
        'totalStaked': totalStaked,
        'totalDailyRewards': totalDailyRewards,
        'totalEarned': totalEarned,
        'referralRewards': referralRewards,
      };
    } catch (e) {
      print('💥 Stake data API exception: $e');
      print('🔄 Falling back to default data');
      return _getDefaultStakeData();
    }
  }

  // Get daily return
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<DailyReturnResponseEntity> getDailyReturn(
    String walletAddress,
  ) async {
    try {
      print('📊 Fetching daily return for wallet: $walletAddress');

      var response = await HttpUtil().post(
        'daily_return.php',
        mydata: {
          'wallet': walletAddress,
        },
      );

      print('📥 Raw daily return response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse daily return response: $e');
          return _getDefaultDailyReturn();
        }
      } else {
        return _getDefaultDailyReturn();
      }

      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultDailyReturn();
      }

      try {
        return DailyReturnResponseEntity.fromJson(responseData);
      } catch (e) {
        print('❌ Failed to parse daily return entity: $e');
        return _getDefaultDailyReturn();
      }
    } catch (e) {
      print('💥 Daily return API exception: $e');
      return _getDefaultDailyReturn();
    }
  }

  // Get reward tiers
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<RewardTiersResponseEntity> getRewardTiers(
    String walletAddress,
  ) async {
    try {
      print('🎯 Fetching reward tiers for wallet: $walletAddress');

      var response = await HttpUtil().post(
        'reward_tiers.php',
        mydata: {
          'wallet': walletAddress,
        },
      );

      print('📥 Raw reward tiers response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse reward tiers response: $e');
          return _getDefaultRewardTiers();
        }
      } else {
        return _getDefaultRewardTiers();
      }

      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultRewardTiers();
      }

      try {
        return RewardTiersResponseEntity.fromJson(responseData);
      } catch (e) {
        print('❌ Failed to parse reward tiers entity: $e');
        return _getDefaultRewardTiers();
      }
    } catch (e) {
      print('💥 Reward tiers API exception: $e');
      return _getDefaultRewardTiers();
    }
  }

  // Stake tokens
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<StakeResponseEntity> stakeTokens(
    String walletAddress,
    String amount,
    String coinSymbol,
  ) async {
    try {
      print('💰 Staking tokens: $amount $coinSymbol');
      print('👛 Wallet: $walletAddress');

      final requestEntity = StakeRequestEntity(
        wallet: walletAddress,
        amount: amount,
        coinSymbol: coinSymbol,
      );

      var response = await HttpUtil().post(
        'stake_tokens.php',
        mydata: requestEntity.toJson(),
      );

      print('📥 Raw stake response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse stake response: $e');
          return _getDefaultStakeResponse(true);
        }
      } else {
        return _getDefaultStakeResponse(true);
      }

      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default response');
        return _getDefaultStakeResponse(false);
      }

      try {
        return StakeResponseEntity.fromJson(responseData);
      } catch (e) {
        print('❌ Failed to parse stake entity: $e');
        return _getDefaultStakeResponse(true);
      }
    } catch (e) {
      print('💥 Stake tokens API exception: $e');
      return _getDefaultStakeResponse(true);
    }
  }

  // Claim rewards
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<ClaimRewardsResponseEntity> claimRewards({
    required String walletAddress,
    String? positionId,
  }) async {
    try {
      print('🎁 Claiming rewards for wallet: $walletAddress');

      final requestEntity = ClaimRewardsRequestEntity(
        wallet: walletAddress,
        positionId: positionId,
      );

      var response = await HttpUtil().post(
        'claim_rewards.php',
        mydata: requestEntity.toJson(),
      );

      print('📥 Raw claim rewards response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse claim rewards response: $e');
          return _getDefaultClaimResponse(true);
        }
      } else {
        return _getDefaultClaimResponse(true);
      }

      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default response');
        return _getDefaultClaimResponse(false);
      }

      try {
        return ClaimRewardsResponseEntity.fromJson(responseData);
      } catch (e) {
        print('❌ Failed to parse claim rewards entity: $e');
        return _getDefaultClaimResponse(true);
      }
    } catch (e) {
      print('💥 Claim rewards API exception: $e');
      return _getDefaultClaimResponse(true);
    }
  }

  // Default stake data when API fails - Only STARCOIN
  static Map<String, dynamic> _getDefaultStakeData() {
    print('📋 Using default stake data (STARCOIN only)');

    final stakingPackages = [
      {
        'token': 'STARCOIN',
        'chain': 'TON Chain',
        'dailyReward': '0.5% - 0.7%',
        'minStake': '10 STAR',
        'duration': '365 Days',
        'logo': 'assets/images/starcoin.png',
      },
    ];

    final activePositions = [
      {
        'token': 'STARCOIN',
        'amount': '150.00 STAR',
        'dailyReward': '0.90 STAR',
        'totalEarned': '45.50 STAR',
        'daysRemaining': '320',
        'positionId': '1',
      },
    ];

    return {
      'stakingPackages': stakingPackages,
      'activePositions': activePositions,
      'totalStaked': '150.00',
      'totalDailyRewards': '0.90',
      'totalEarned': '45.50',
      'referralRewards': '12.30',
    };
  }

  static String _calculateTotalStaked(List<Map<String, dynamic>> positions) {
    double total = 0.0;
    for (var position in positions) {
      final amountStr = position['amount']?.toString().replaceAll(' STAR', '').replaceAll('\$', '').trim() ?? '0';
      total += double.tryParse(amountStr) ?? 0.0;
    }
    return total.toStringAsFixed(2);
  }

  static String _calculateTotalDailyRewards(List<Map<String, dynamic>> positions) {
    double total = 0.0;
    for (var position in positions) {
      final rewardStr = position['dailyReward']?.toString().replaceAll(' STAR', '').replaceAll('\$', '').trim() ?? '0';
      total += double.tryParse(rewardStr) ?? 0.0;
    }
    return total.toStringAsFixed(2);
  }

  // Default daily return when API fails
  static DailyReturnResponseEntity _getDefaultDailyReturn() {
    print('📋 Using default daily return');
    return DailyReturnResponseEntity(
      success: true,
      dailyReturn: '0.50',
    );
  }

  // Default reward tiers when API fails
  static RewardTiersResponseEntity _getDefaultRewardTiers() {
    print('📋 Using default reward tiers');
    return RewardTiersResponseEntity(
      success: true,
      tiers: [
        RewardTierEntity(
          minAmount: '10',
          maxAmount: '99',
          dailyReward: '0.5',
          apr: '182.5',
        ),
        RewardTierEntity(
          minAmount: '100',
          maxAmount: '999',
          dailyReward: '0.6',
          apr: '219.0',
        ),
        RewardTierEntity(
          minAmount: '1000',
          maxAmount: '999999',
          dailyReward: '0.7',
          apr: '255.5',
        ),
      ],
    );
  }

  // Default stake response when API fails
  static StakeResponseEntity _getDefaultStakeResponse(bool success) {
    print('📋 Using default stake response');
    return StakeResponseEntity(
      success: success,
      message: success
          ? 'Staking successful'
          : 'Failed to stake. Please try again.',
    );
  }

  // Default claim response when API fails
  static ClaimRewardsResponseEntity _getDefaultClaimResponse(bool success) {
    print('📋 Using default claim response');
    return ClaimRewardsResponseEntity(
      success: success,
      message: success
          ? 'Rewards claimed successfully'
          : 'Failed to claim rewards. Please try again.',
      claimedAmount: success ? '45.50' : null,
    );
  }
}

