// swap_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/swap_api.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/swap/bloc/swap_bloc.dart';
import 'package:wal/pages/swap/bloc/swap_event.dart';

class SwapController {
  final BuildContext context;

  const SwapController({required this.context});

  /// Main method to load swap data
  Future<void> loadSwapData() async {
    try {
      print('🔄 Starting to load swap data...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        context.read<SwapBloc>().setError('No wallet address found');
        toastInfo(msg: "Please login first");
        return;
      }

      print('👛 Wallet address: $walletAddress');

      // Show loading
      context.read<SwapBloc>().add(LoadingEvent(true));

      try {
        // Call API to get swap data
        final swapData = await SwapAPI.getSwapData(walletAddress);

        print('✅ Received swap data');

        // Update bloc with data
        context.read<SwapBloc>().setSwapData(
          List<Map<String, dynamic>>.from(swapData['availableAssets']),
          List<Map<String, dynamic>>.from(swapData['recentSwaps']),
        );

        // Set default from/to assets if not set
        final state = context.read<SwapBloc>().state;
        if (state.fromAsset == null && swapData['availableAssets'].isNotEmpty) {
          context.read<SwapBloc>().add(
            SelectFromAssetEvent(swapData['availableAssets'][0]),
          );
        }
        if (state.toAsset == null && swapData['availableAssets'].length > 1) {
          context.read<SwapBloc>().add(
            SelectToAssetEvent(swapData['availableAssets'][1]),
          );
        }

        print('✅ Swap data loaded successfully');
      } catch (e) {
        // Handle API call errors - API already returns default data
        await _handleApiError(e);
      }
    } catch (e) {
      // Handle unexpected errors
      await _handleUnexpectedError(e);
    }
  }

  /// Refresh swap data
  Future<void> refreshSwapData() async {
    try {
      print('🔄 Refreshing swap data...');

      final walletAddress = await _getWalletAddress();
      if (walletAddress.isEmpty) {
        context.read<SwapBloc>().setError('No wallet address found');
        return;
      }

      context.read<SwapBloc>().add(LoadingEvent(true));

      try {
        final swapData = await SwapAPI.getSwapData(walletAddress);
        context.read<SwapBloc>().setSwapData(
          List<Map<String, dynamic>>.from(swapData['availableAssets']),
          List<Map<String, dynamic>>.from(swapData['recentSwaps']),
        );
        print('✅ Swap data refreshed successfully');
      } catch (e) {
        await _handleApiError(e);
      }
    } catch (e) {
      await _handleUnexpectedError(e);
    }
  }

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

  /// Handle API call errors
  Future<void> _handleApiError(dynamic e) async {
    context.read<SwapBloc>().setLoading(false);
    print('🌐 API Error: ${e.toString()}');

    // API already returns default data, so just log the error
    // Don't show error to user since default data is available
    print('ℹ️ Using default swap data');
  }

  /// Handle unexpected errors
  Future<void> _handleUnexpectedError(dynamic e) async {
    context.read<SwapBloc>().setLoading(false);
    print('💥 Unexpected error in SwapController: ${e.toString()}');
    
    // Even on error, try to use default data
    final walletAddress = await _getWalletAddress();
    if (walletAddress.isNotEmpty) {
      try {
        final defaultData = SwapAPI.getSwapData(walletAddress);
        // This will use default data internally
        final swapData = await defaultData;
        context.read<SwapBloc>().setSwapData(
          List<Map<String, dynamic>>.from(swapData['availableAssets']),
          List<Map<String, dynamic>>.from(swapData['recentSwaps']),
        );
      } catch (e2) {
        context.read<SwapBloc>().setError('Failed to load swap data');
        toastInfo(msg: "Using default swap data");
      }
    } else {
      context.read<SwapBloc>().setError('No wallet address found');
      toastInfo(msg: "Please login first");
    }
  }
}

