// sign_in_controller.dart - COMPLETE UPDATED VERSION
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wal/common/apis/user_api.dart';
import 'package:wal/common/entities/user.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/common/values/constant.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_event.dart';

class SignInController {
  final BuildContext context;

  const SignInController({required this.context});

  /// Main method to handle the sign-in process
  Future<void> handleSignIn(String type) async {
    try {
      // Only handle email/username login for now
      if (type == "email") {
        // Step 1: Get the current state from the sign-in form
        final state = context.read<SignInBloc>().state;
        String username = state.username;
        String password = state.password;

        print('🔐 Starting sign-in process...');
        print('👤 Username: $username');
        print('🔒 Password: ${'*' * password.length}'); // Mask password in logs

        // Step 2: Validate user input
        if (!_validateInput(username, password)) {
          return; // Stop if validation fails
        }

        // Step 3: Show loading indicator
        await _showLoading();

        try {
          // Step 4: Create login request object
          LoginRequestEntity loginRequestEntity = LoginRequestEntity(
            username: username,
            password: password,
          );

          print('📤 Sending login request to server...');

          // Step 5: Call the API to login
          var result = await UserAPI.login(params: loginRequestEntity);

          // Step 6: Handle the API response
          await _handleLoginResponse(result, username);
        } catch (e) {
          // Handle API call errors
          await _handleApiError(e);
        }
      }
    } catch (e) {
      // Handle unexpected errors
      await _handleUnexpectedError(e);
    }
  }

  /// Step 2: Validate user input
  bool _validateInput(String username, String password) {
    // Check if username is empty
    if (username.isEmpty) {
      toastInfo(msg: "Please enter your username");
      return false;
    }

    // Check if password is empty
    if (password.isEmpty) {
      toastInfo(msg: "Please enter your password");
      return false;
    }

    // Check password length (optional requirement)
    if (password.length < 6) {
      toastInfo(msg: "Password must be at least 6 characters");
      return false;
    }

    print('✅ Input validation passed');
    return true;
  }

  /// Step 3: Show loading indicator
  Future<void> _showLoading() async {
    await EasyLoading.show(
      status: 'Signing in...',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  /// Step 6: Handle the API response
  Future<void> _handleLoginResponse(
    UserLoginResponseEntity result,
    String username,
  ) async {
    // Check if login was successful
    if (result.isSuccess) {
      print('🎉 Login successful!');
      print('👛 Wallet address: ${result.wallet}');
      print('📝 Mnemonic received: ${result.mnemonic.isNotEmpty}');

      try {
        // Step 7: Save user data to local storage
        await _saveUserData(username, result.wallet, result.mnemonic);

        // Step 8: Dismiss loading and show success
        EasyLoading.dismiss();
        toastInfo(msg: "Login Successful! 🎉");

        // Small delay to ensure storage is written
        await Future.delayed(const Duration(milliseconds: 200));

        // Step 9: Navigate to main app
        await _navigateToApplication();
      } catch (e) {
        // Handle errors during data saving
        EasyLoading.dismiss();
        print('❌ Error saving user data: ${e.toString()}');
        toastInfo(msg: "Login successful but failed to save data");
      }
    } else {
      // Login failed - show error message from server
      EasyLoading.dismiss();
      print('❌ Login failed: ${result.report}');
      toastInfo(
        msg: result.report,
      ); // Shows "Incorrect Login Details" or similar
    }
  }

  /// Step 7: Save user data to local storage
  Future<void> _saveUserData(
    String username,
    String wallet,
    String mnemonic,
  ) async {
    try {
      print('💾 Saving user data to local storage...');
      print('👛 Wallet to save: $wallet');

      // Create user profile data
      Map<String, dynamic> userData = {
        "username": username,
        "wallet": wallet,
        "login_time": DateTime.now().toIso8601String(),
      };

      // Save user profile to shared preferences
      await Global.storageService.setString(
        AppConstants.STORAGE_USER_PROFILE_KEY,
        jsonEncode(userData),
      );

      // Save wallet data (you might want to use secure storage for mnemonic)
      await Global.storageService.setUserWallet(wallet, mnemonic);

      // Save authentication token
      await _saveAuthToken();

      // DEBUG: Check what's actually in storage
      Global.storageService.debugStorage();

      print('✅ User data saved successfully');
      print('📝 Username: $username');
      print('👛 Wallet: ${wallet.isNotEmpty ? "Received" : "Not provided"}');
      print('🔐 Mnemonic: ${mnemonic.isNotEmpty ? "Saved" : "Not provided"}');
    } catch (e) {
      print('❌ Error saving user data: ${e.toString()}');
      throw Exception('Failed to save user data: ${e.toString()}');
    }
  }

  /// Save wallet-specific data
  Future<void> _saveWalletData(String wallet, String mnemonic) async {
    try {
      // For now, using shared preferences
      // In production, consider using flutter_secure_storage for mnemonic
      await Global.storageService.setString('user_wallet', wallet);
      await Global.storageService.setString('user_mnemonic', mnemonic);

      print('💰 Wallet data saved');
    } catch (e) {
      print('⚠️ Could not save wallet data: $e');
      // Don't throw error here - wallet data is important but shouldn't block login
    }
  }

  /// Save authentication token
  Future<void> _saveAuthToken() async {
    try {
      // Create a simple token (in real app, you'd get this from API)
      String token = "logged_in_${DateTime.now().millisecondsSinceEpoch}";

      await Global.storageService.setString(
        AppConstants.STORAGE_USER_TOKEN_KEY,
        token,
      );

      print('🔑 Auth token saved: $token');
    } catch (e) {
      print('⚠️ Could not save auth token: $e');
      throw Exception('Failed to save authentication token');
    }
  }

  /// Step 9: Navigate to main application
  Future<void> _navigateToApplication() async {
    // Small delay to let user see success message
    await Future.delayed(const Duration(milliseconds: 500));

    if (context.mounted) {
      print('🚀 Navigating to main application...');

      // Navigate and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.APPLICATION,
        (route) => false, // Remove all previous routes from stack
      );
    } else {
      print('⚠️ Context not mounted, cannot navigate');
    }
  }

  /// Handle API call errors
  Future<void> _handleApiError(dynamic e) async {
    EasyLoading.dismiss();
    print('🌐 API Error: ${e.toString()}');

    // Show user-friendly error message
    String errorMessage = "Network error. Please check your connection.";

    // Check for specific error types
    if (e.toString().contains("SocketException") ||
        e.toString().contains("Network is unreachable")) {
      errorMessage = "No internet connection. Please check your network.";
    } else if (e.toString().contains("Timeout")) {
      errorMessage = "Server is taking too long to respond. Please try again.";
    }

    toastInfo(msg: errorMessage);
  }

  /// Handle unexpected errors
  Future<void> _handleUnexpectedError(dynamic e) async {
    EasyLoading.dismiss();
    print('💥 Unexpected error in SignInController: ${e.toString()}');
    toastInfo(msg: "An unexpected error occurred. Please try again.");
  }

  /// Optional: Method to clear form data
  void clearForm() {
    final bloc = context.read<SignInBloc>();
    bloc.add(UsernameEvent(""));
    bloc.add(PasswordEvent(""));
    print('🧹 Sign-in form cleared');
  }

  /// Optional: Method to check if user can proceed with login
  bool canProceedWithLogin() {
    final state = context.read<SignInBloc>().state;
    return state.username.isNotEmpty &&
        state.password.isNotEmpty &&
        state.password.length >= 6;
  }
}
