// stake_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/stake_api.dart';
import 'package:wal/common/entities/stake.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/earn/bloc/stake_bloc.dart';
import 'package:wal/pages/earn/bloc/stake_event.dart';

class StakeController {
  final BuildContext context;
  static bool _isLoading = false;

  const StakeController({required this.context});

  /// Get wallet address from storage
  Future<String> _getWalletAddress() async {
    try {
      final wallet = await Global.storageService.getUserWallet();
      return wallet.isNotEmpty ? wallet : "";
    } catch (e) {
      print('❌ Error getting wallet address: $e');
      return "";
    }
  }

  /// Main method to load stake data
  // Note: Wallet address is required - backend uses it to identify the user
  Future<void> loadStakeData() async {
    // Prevent multiple simultaneous calls
    if (_isLoading) {
      print('⚠️ Stake data is already loading, skipping...');
      return;
    }

    if (!context.mounted) {
      print('⚠️ Context not mounted, skipping load...');
      return;
    }

    try {
      _isLoading = true;
      print('💰 Starting to load stake data...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        _isLoading = false;
        if (context.mounted) {
          context.read<StakeBloc>().add(LoadingEvent(false));
          toastInfo(msg: "Wallet address not found");
        }
        return;
      }

      print('👛 Wallet address: $walletAddress');

      // Show loading
      if (context.mounted) {
        context.read<StakeBloc>().add(LoadingEvent(true));
      }

      try {
        // Call API to get stake data (wallet included in request)
        final stakeData = await StakeAPI.getStakeData(walletAddress);

        // Load daily return and reward tiers
        final dailyReturn = await StakeAPI.getDailyReturn(walletAddress);
        final rewardTiers = await StakeAPI.getRewardTiers(walletAddress);

        print('✅ Received stake data');

        // Update bloc with data
        context.read<StakeBloc>().setStakeData(
          List<Map<String, dynamic>>.from(stakeData['stakingPackages']),
          List<Map<String, dynamic>>.from(stakeData['activePositions']),
          stakeData['totalStaked']?.toString() ?? '0.00',
          stakeData['totalDailyRewards']?.toString() ?? '0.00',
          stakeData['totalEarned']?.toString() ?? '0.00',
          stakeData['referralRewards']?.toString() ?? '0.00',
        );

        // Update daily return and reward tiers
        if (dailyReturn.isSuccess) {
          context.read<StakeBloc>().setDailyReturn(dailyReturn.dailyReturn);
        }
        if (rewardTiers.isSuccess) {
          context.read<StakeBloc>().setRewardTiers(rewardTiers.tiers);
        }

        print('✅ Stake data loaded successfully');
      } catch (e) {
        // Handle API call errors - API already returns default data
        await _handleApiError(e);
      } finally {
        _isLoading = false;
      }
    } catch (e) {
      // Handle unexpected errors
      await _handleUnexpectedError(e);
      _isLoading = false;
    }
  }

  /// Refresh stake data
  // Note: Wallet is not needed - backend identifies user from authentication token/session
  Future<void> refreshStakeData() async {
    // Prevent multiple simultaneous calls
    if (_isLoading) {
      print('⚠️ Stake data is already loading, skipping refresh...');
      return;
    }

    if (!context.mounted) {
      print('⚠️ Context not mounted, skipping refresh...');
      return;
    }

    try {
      _isLoading = true;
      print('🔄 Refreshing stake data...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        _isLoading = false;
        if (context.mounted) {
          context.read<StakeBloc>().add(LoadingEvent(false));
        }
        return;
      }

      if (context.mounted) {
        context.read<StakeBloc>().add(LoadingEvent(true));
      }

      try {
        final stakeData = await StakeAPI.getStakeData(walletAddress);
        final dailyReturn = await StakeAPI.getDailyReturn(walletAddress);
        final rewardTiers = await StakeAPI.getRewardTiers(walletAddress);

        context.read<StakeBloc>().setStakeData(
          List<Map<String, dynamic>>.from(stakeData['stakingPackages']),
          List<Map<String, dynamic>>.from(stakeData['activePositions']),
          stakeData['totalStaked']?.toString() ?? '0.00',
          stakeData['totalDailyRewards']?.toString() ?? '0.00',
          stakeData['totalEarned']?.toString() ?? '0.00',
          stakeData['referralRewards']?.toString() ?? '0.00',
        );

        if (dailyReturn.isSuccess) {
          context.read<StakeBloc>().setDailyReturn(dailyReturn.dailyReturn);
        }
        if (rewardTiers.isSuccess) {
          context.read<StakeBloc>().setRewardTiers(rewardTiers.tiers);
        }

        print('✅ Stake data refreshed successfully');
      } catch (e) {
        await _handleApiError(e);
      } finally {
        _isLoading = false;
      }
    } catch (e) {
      await _handleUnexpectedError(e);
      _isLoading = false;
    }
  }

  /// Stake tokens
  // Note: Wallet address is required - backend uses it to identify the user
  Future<void> stakeTokens(String amount, String coinSymbol) async {
    if (!context.mounted) {
      print('⚠️ Context not mounted, skipping stake...');
      return;
    }

    try {
      print('💰 Starting to stake tokens...');
      print('💰 Amount: $amount $coinSymbol');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        if (context.mounted) {
          context.read<StakeBloc>().setStakeError("Wallet address not found");
          toastInfo(msg: "Wallet address not found");
        }
        return;
      }

      print('👛 Wallet address: $walletAddress');

      if (context.mounted) {
        context.read<StakeBloc>().setStaking(true);
      }

      try {
        final result = await StakeAPI.stakeTokens(walletAddress, amount, coinSymbol);

        if (context.mounted) {
          if (result.isSuccess) {
            context.read<StakeBloc>().setStakeSuccess(result.message);
            toastInfo(msg: result.message);
            print('✅ Staking successful');
          } else {
            context.read<StakeBloc>().setStakeError(
              result.error ?? result.message,
            );
            toastInfo(msg: result.error ?? result.message);
            print('❌ Staking failed: ${result.error ?? result.message}');
          }
        }
      } catch (e) {
        await _handleStakeApiError(e);
      }
    } catch (e) {
      await _handleStakeUnexpectedError(e);
    }
  }

  /// Claim rewards
  // Note: Wallet address is required - backend uses it to identify the user
  Future<void> claimRewards({String? positionId}) async {
    if (!context.mounted) {
      print('⚠️ Context not mounted, skipping claim...');
      return;
    }

    try {
      print('🎁 Starting to claim rewards...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        if (context.mounted) {
          context.read<StakeBloc>().setClaimError("Wallet address not found");
          toastInfo(msg: "Wallet address not found");
        }
        return;
      }

      print('👛 Wallet address: $walletAddress');

      if (context.mounted) {
        context.read<StakeBloc>().setClaiming(true);
      }

      try {
        final result = await StakeAPI.claimRewards(
          walletAddress: walletAddress,
          positionId: positionId,
        );

        if (context.mounted) {
          if (result.isSuccess) {
            context.read<StakeBloc>().setClaimSuccess(
              result.message,
              claimedAmount: result.claimedAmount,
            );
            toastInfo(msg: result.message);
            print('✅ Claim successful');
          } else {
            context.read<StakeBloc>().setClaimError(
              result.error ?? result.message,
            );
            toastInfo(msg: result.error ?? result.message);
            print('❌ Claim failed: ${result.error ?? result.message}');
          }
        }
      } catch (e) {
        await _handleClaimApiError(e);
      }
    } catch (e) {
      await _handleClaimUnexpectedError(e);
    }
  }

  /// Handle API call errors
  Future<void> _handleApiError(dynamic e) async {
    if (context.mounted) {
      context.read<StakeBloc>().setLoading(false);
    }
    print('🌐 API Error: ${e.toString()}');

    // Use default data immediately without making more API calls
    print('ℹ️ Using default stake data');
    if (context.mounted) {
      final defaultData = _getDefaultStakeData();
      context.read<StakeBloc>().setStakeData(
        List<Map<String, dynamic>>.from(defaultData['stakingPackages']),
        List<Map<String, dynamic>>.from(defaultData['activePositions']),
        defaultData['totalStaked']?.toString() ?? '0.00',
        defaultData['totalDailyRewards']?.toString() ?? '0.00',
        defaultData['totalEarned']?.toString() ?? '0.00',
        defaultData['referralRewards']?.toString() ?? '0.00',
      );
      context.read<StakeBloc>().setDailyReturn('0.50');
      context.read<StakeBloc>().setRewardTiers(_getDefaultRewardTiers());
    }
  }

  Map<String, dynamic> _getDefaultStakeData() {
    return {
      'stakingPackages': [
        {
          'token': 'STARCOIN',
          'chain': 'TON Chain',
          'dailyReward': '0.5% - 0.7%',
          'minStake': '10 STAR',
          'duration': '365 Days',
          'logo': 'assets/images/starcoin.png',
        },
      ],
      'activePositions': [],
      'totalStaked': '0.00',
      'totalDailyRewards': '0.00',
      'totalEarned': '0.00',
      'referralRewards': '0.00',
    };
  }

  List<RewardTierEntity> _getDefaultRewardTiers() {
    return [
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
    ];
  }

  /// Handle unexpected errors
  Future<void> _handleUnexpectedError(dynamic e) async {
    if (context.mounted) {
      context.read<StakeBloc>().setLoading(false);
    }
    print('💥 Unexpected error in StakeController: ${e.toString()}');

    // Use default data immediately without making more API calls
    if (context.mounted) {
      final defaultData = _getDefaultStakeData();
      context.read<StakeBloc>().setStakeData(
        List<Map<String, dynamic>>.from(defaultData['stakingPackages']),
        List<Map<String, dynamic>>.from(defaultData['activePositions']),
        defaultData['totalStaked']?.toString() ?? '0.00',
        defaultData['totalDailyRewards']?.toString() ?? '0.00',
        defaultData['totalEarned']?.toString() ?? '0.00',
        defaultData['referralRewards']?.toString() ?? '0.00',
      );
      context.read<StakeBloc>().setDailyReturn('0.50');
      context.read<StakeBloc>().setRewardTiers(_getDefaultRewardTiers());
      toastInfo(msg: "Using default stake data");
    }
  }

  /// Handle stake API errors
  Future<void> _handleStakeApiError(dynamic e) async {
    if (context.mounted) {
      context.read<StakeBloc>().setStaking(false);
    }
    print('🌐 Stake API Error: ${e.toString()}');
    print('ℹ️ Using default stake response');
  }

  /// Handle stake unexpected errors
  Future<void> _handleStakeUnexpectedError(dynamic e) async {
    if (context.mounted) {
      context.read<StakeBloc>().setStaking(false);
    }
    print('💥 Unexpected error in StakeController (stake): ${e.toString()}');

    if (context.mounted) {
      try {
        final walletAddress = await _getWalletAddress();
        if (walletAddress.isEmpty) {
          context.read<StakeBloc>().setStakeError('Wallet address not found');
          return;
        }
        final result = await StakeAPI.stakeTokens(walletAddress, '0', 'STARCOIN');
        if (context.mounted) {
          if (result.isSuccess) {
            context.read<StakeBloc>().setStakeSuccess(result.message);
          } else {
            context.read<StakeBloc>().setStakeError(
              result.error ?? result.message,
            );
          }
        }
      } catch (e2) {
        if (context.mounted) {
          context.read<StakeBloc>().setStakeError('Failed to stake tokens');
          toastInfo(msg: "Using default stake response");
        }
      }
    }
  }

  /// Handle claim API errors
  Future<void> _handleClaimApiError(dynamic e) async {
    if (context.mounted) {
      context.read<StakeBloc>().setClaiming(false);
    }
    print('🌐 Claim API Error: ${e.toString()}');
    print('ℹ️ Using default claim response');
  }

  /// Handle claim unexpected errors
  Future<void> _handleClaimUnexpectedError(dynamic e) async {
    if (context.mounted) {
      context.read<StakeBloc>().setClaiming(false);
    }
    print('💥 Unexpected error in StakeController (claim): ${e.toString()}');

    if (context.mounted) {
      try {
        final walletAddress = await _getWalletAddress();
        if (walletAddress.isEmpty) {
          context.read<StakeBloc>().setClaimError('Wallet address not found');
          return;
        }
        final result = await StakeAPI.claimRewards(walletAddress: walletAddress);
        if (context.mounted) {
          if (result.isSuccess) {
            context.read<StakeBloc>().setClaimSuccess(result.message);
          } else {
            context.read<StakeBloc>().setClaimError(
              result.error ?? result.message,
            );
          }
        }
      } catch (e2) {
        if (context.mounted) {
          context.read<StakeBloc>().setClaimError('Failed to claim rewards');
          toastInfo(msg: "Using default claim response");
        }
      }
    }
  }
}
