// receive_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/receive_api.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/receive/bloc/receive_bloc.dart';
import 'package:wal/pages/receive/bloc/receive_event.dart';

class ReceiveController {
  final BuildContext context;

  const ReceiveController({required this.context});

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

  /// Main method to load receive addresses
  // Note: Wallet address is required - backend uses it to identify the user
  Future<void> loadReceiveAddresses() async {
    try {
      print('📥 Starting to load receive addresses...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();

      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        context.read<ReceiveBloc>().add(LoadingEvent(false));
        toastInfo(msg: "Wallet address not found");
        return;
      }

      print('👛 Wallet address: $walletAddress');

      // Show loading
      context.read<ReceiveBloc>().add(LoadingEvent(true));

      try {
        // Call API to get receive addresses (wallet included in request)
        final assets = await ReceiveAPI.getReceiveAddresses(walletAddress);

        print('✅ Received ${assets.length} assets');

        // Update bloc with assets
        context.read<ReceiveBloc>().setAssets(assets);

        print('✅ Receive addresses loaded successfully');
      } catch (e) {
        // Handle API call errors - API already returns default data
        await _handleApiError(e);
      }
    } catch (e) {
      // Handle unexpected errors
      await _handleUnexpectedError(e);
    }
  }

  /// Refresh receive addresses
  // Note: Wallet address is required - backend uses it to identify the user
  Future<void> refreshReceiveAddresses() async {
    try {
      print('🔄 Refreshing receive addresses...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();

      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        context.read<ReceiveBloc>().add(LoadingEvent(false));
        return;
      }

      context.read<ReceiveBloc>().add(LoadingEvent(true));

      try {
        final assets = await ReceiveAPI.getReceiveAddresses(walletAddress);
        context.read<ReceiveBloc>().setAssets(assets);
        print('✅ Receive addresses refreshed successfully');
      } catch (e) {
        await _handleApiError(e);
      }
    } catch (e) {
      await _handleUnexpectedError(e);
    }
  }

  /// Handle API call errors
  Future<void> _handleApiError(dynamic e) async {
    context.read<ReceiveBloc>().setLoading(false);
    print('🌐 API Error: ${e.toString()}');

    // API already returns default data, so just log the error
    // Don't show error to user since default data is available
    print('ℹ️ Using default receive addresses');
  }

  /// Handle unexpected errors
  Future<void> _handleUnexpectedError(dynamic e) async {
    context.read<ReceiveBloc>().setLoading(false);
    print('💥 Unexpected error in ReceiveController: ${e.toString()}');

    // Even on error, try to use default data
    try {
      final walletAddress = await _getWalletAddress();
      if (walletAddress.isEmpty) {
        context.read<ReceiveBloc>().setError(
          'Failed to load receive addresses',
        );
        toastInfo(msg: "Using default addresses");
        return;
      }
      final defaultAssets = ReceiveAPI.getReceiveAddresses(walletAddress);
      // This will use default data internally
      context.read<ReceiveBloc>().setAssets(await defaultAssets);
    } catch (e2) {
      context.read<ReceiveBloc>().setError('Failed to load receive addresses');
      toastInfo(msg: "Using default addresses");
    }
  }
}
