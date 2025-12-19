// home_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/home/bloc/home_bloc.dart';
import 'package:wal/pages/home/bloc/home_event.dart';

class HomeController {
  final BuildContext context;

  const HomeController({required this.context});

  /// Main method to load home data
  Future<void> loadHomeData() async {
    try {
      print('🏠 Starting to load home data...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        context.read<HomeBloc>().add(const HomeLoadData());
        return;
      }

      print('👛 Wallet address: $walletAddress');

      // Trigger bloc to load data (bloc will call HomeAPI)
      context.read<HomeBloc>().add(const HomeLoadData());

      print('✅ Home data load initiated');
    } catch (e) {
      // Handle unexpected errors
      await _handleUnexpectedError(e);
    }
  }

  /// Refresh home data
  Future<void> refreshHomeData() async {
    try {
      print('🔄 Refreshing home data...');

      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        context.read<HomeBloc>().add(const HomeRefreshData());
        return;
      }

      // Trigger bloc to refresh data (bloc will call HomeAPI)
      context.read<HomeBloc>().add(const HomeRefreshData());

      print('✅ Home data refresh initiated');
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

  /// Handle unexpected errors
  Future<void> _handleUnexpectedError(dynamic e) async {
    print('💥 Unexpected error in HomeController: ${e.toString()}');
    
    // Trigger bloc to load default data
    context.read<HomeBloc>().add(const HomeLoadData());
    toastInfo(msg: "Using default data");
  }
}

