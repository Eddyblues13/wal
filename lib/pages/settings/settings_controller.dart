// settings_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/settings_api.dart';
import 'package:wal/common/apis/user_api.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/common/values/constant.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/settings/bloc/settings_bloc.dart';
import 'package:wal/pages/settings/bloc/settings_event.dart';

class SettingsController {
  final BuildContext context;

  const SettingsController({required this.context});

  bool get _isMounted => context.mounted;

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

  /// Main method to load settings data
  // Note: Wallet address is required - backend uses it to identify the user
  Future<void> loadSettingsData() async {
    try {
      print('⚙️ Starting to load settings data...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        if (_isMounted) {
          context.read<SettingsBloc>().add(LoadingEvent(false));
          toastInfo(msg: "Wallet address not found");
        }
        return;
      }

      print('👛 Wallet address: $walletAddress');

      // Show loading
      if (_isMounted) {
        context.read<SettingsBloc>().add(LoadingEvent(true));
      }

      try {
        // Call API to get settings data (wallet included in request)
        final settingsData = await SettingsAPI.getSettingsData(walletAddress);
        
        // Load about links
        final aboutLinks = await SettingsAPI.getAboutLinks(walletAddress);

        print('✅ Received settings data');

        // Update bloc with data
        if (_isMounted) {
          context.read<SettingsBloc>().setSettingsData(
            settingsData.userProfile,
            settingsData.referralCode,
            settingsData.xLink,
            settingsData.telegramLink,
          );
          
          // Update about links
          context.read<SettingsBloc>().setAboutLinks(
            aboutLinks.privacyPolicyUrl,
            aboutLinks.termsOfServiceUrl,
            aboutLinks.openSourceLicensesUrl,
          );
        }

        print('✅ Settings data loaded successfully');
      } catch (e) {
        // Handle API call errors - API already returns default data
        await _handleApiError(e);
      }
    } catch (e) {
      // Handle unexpected errors
      await _handleUnexpectedError(e);
    }
  }

  /// Refresh settings data
  // Note: Wallet address is required - backend uses it to identify the user
  Future<void> refreshSettingsData() async {
    try {
      print('🔄 Refreshing settings data...');

      // Get wallet address from storage
      final walletAddress = await _getWalletAddress();
      
      if (walletAddress.isEmpty) {
        print('⚠️ No wallet address found');
        if (_isMounted) {
          context.read<SettingsBloc>().add(LoadingEvent(false));
        }
        return;
      }

      if (_isMounted) {
        context.read<SettingsBloc>().add(LoadingEvent(true));
      }

      try {
        final settingsData = await SettingsAPI.getSettingsData(walletAddress);
        final aboutLinks = await SettingsAPI.getAboutLinks(walletAddress);
        
        if (_isMounted) {
          context.read<SettingsBloc>().setSettingsData(
            settingsData.userProfile,
            settingsData.referralCode,
            settingsData.xLink,
            settingsData.telegramLink,
          );
          
          context.read<SettingsBloc>().setAboutLinks(
            aboutLinks.privacyPolicyUrl,
            aboutLinks.termsOfServiceUrl,
            aboutLinks.openSourceLicensesUrl,
          );
        }
        print('✅ Settings data refreshed successfully');
      } catch (e) {
        await _handleApiError(e);
      }
    } catch (e) {
      await _handleUnexpectedError(e);
    }
  }

  /// Handle API call errors
  Future<void> _handleApiError(dynamic e) async {
    if (_isMounted) {
      context.read<SettingsBloc>().setLoading(false);
    }
    print('🌐 API Error: ${e.toString()}');

    // API already returns default data, so just log the error
    // Don't show error to user since default data is available
    print('ℹ️ Using default settings data');
  }

  /// Handle unexpected errors
  Future<void> _handleUnexpectedError(dynamic e) async {
    if (_isMounted) {
      context.read<SettingsBloc>().setLoading(false);
    }
    print('💥 Unexpected error in SettingsController: ${e.toString()}');
    
    // Even on error, try to use default data
    try {
      final walletAddress = await _getWalletAddress();
      if (walletAddress.isEmpty) {
        if (_isMounted) {
          context.read<SettingsBloc>().setError('Failed to load settings data');
        }
        toastInfo(msg: "Using default settings");
        return;
      }
      final defaultData = await SettingsAPI.getSettingsData(walletAddress);
      final defaultAboutLinks = await SettingsAPI.getAboutLinks(walletAddress);
      
      if (_isMounted) {
        context.read<SettingsBloc>().setSettingsData(
          defaultData.userProfile,
          defaultData.referralCode,
          defaultData.xLink,
          defaultData.telegramLink,
        );
        
        context.read<SettingsBloc>().setAboutLinks(
          defaultAboutLinks.privacyPolicyUrl,
          defaultAboutLinks.termsOfServiceUrl,
          defaultAboutLinks.openSourceLicensesUrl,
        );
      }
    } catch (e2) {
      if (_isMounted) {
        context.read<SettingsBloc>().setError('Failed to load settings data');
      }
      toastInfo(msg: "Using default settings");
    }
  }

  /// Logout user
  Future<void> logout() async {
    // Save Navigator reference before async operations
    final navigator = _isMounted ? Navigator.of(context) : null;
    final bloc = _isMounted ? context.read<SettingsBloc>() : null;

    try {
      print('🚪 Starting logout process...');

      // Show loading
      if (_isMounted && bloc != null) {
        bloc.add(LoadingEvent(true));
      }

      try {
        // Call logout API
        final result = await UserAPI.logout();
        
        if (result.success) {
          print('✅ Logout API successful');
        } else {
          print('⚠️ Logout API returned error: ${result.error}');
          // Continue with logout even if API fails
        }
      } catch (e) {
        print('⚠️ Logout API error: $e');
        // Continue with logout even if API fails
      }

      // Clear local storage
      await _clearLocalStorage();

      // Navigate to sign-in page using saved Navigator reference
      if (navigator != null) {
        navigator.pushNamedAndRemoveUntil(
          AppRoutes.SIGN_IN,
          (route) => false, // Remove all previous routes
        );
        print('✅ Logout completed successfully');
      } else {
        print('⚠️ Navigator not available, logout may be incomplete');
      }
    } catch (e) {
      print('💥 Logout error: ${e.toString()}');
      
      // Even on error, try to clear storage and navigate
      try {
        await _clearLocalStorage();
        if (navigator != null) {
          navigator.pushNamedAndRemoveUntil(
            AppRoutes.SIGN_IN,
            (route) => false,
          );
        } else {
          print('⚠️ Navigator not available for error recovery');
          toastInfo(msg: "Logout error. Please try again.");
        }
      } catch (e2) {
        print('💥 Error during cleanup: ${e2.toString()}');
        toastInfo(msg: "Logout error. Please try again.");
      }
    }
  }

  /// Clear all local storage
  Future<void> _clearLocalStorage() async {
    try {
      print('🧹 Clearing local storage...');

      // Remove user token
      await Global.storageService.remove(AppConstants.STORAGE_USER_TOKEN_KEY);
      print('✅ Removed user token');

      // Remove user profile
      await Global.storageService.remove(AppConstants.STORAGE_USER_PROFILE_KEY);
      print('✅ Removed user profile');

      // Remove wallet and mnemonic
      await Global.storageService.remove('user_wallet');
      await Global.storageService.remove('user_mnemonic');
      print('✅ Removed wallet and mnemonic');

      print('✅ Local storage cleared successfully');
    } catch (e) {
      print('❌ Error clearing local storage: $e');
      // Don't throw - continue with logout
    }
  }
}

