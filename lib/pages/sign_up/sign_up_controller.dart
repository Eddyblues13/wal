import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wal/common/apis/user_api.dart';
import 'package:wal/common/entities/user.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/common/values/constant.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_bloc.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_event.dart';
import 'package:wal/pages/seed_phrase/seed_phrase_page.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_state.dart';

class SignUpController {
  final BuildContext context;

  const SignUpController({required this.context});

  Future<void> handleSignUp() async {
    try {
      final state = context.read<SignUpBloc>().state;
      String emailAddress = state.email;
      String password = state.password;
      String confirmPassword = state.confirmPassword;
      String firstName = state.firstName;
      String lastName = state.lastName;

      // Clear previous errors
      context.read<SignUpBloc>().add(ErrorEvent(""));

      // Validation
      if (firstName.isEmpty) {
        context.read<SignUpBloc>().add(
          ErrorEvent("Please enter your first name"),
        );
        _showErrorSnackbar("Please enter your first name");
        return;
      }

      if (lastName.isEmpty) {
        context.read<SignUpBloc>().add(
          ErrorEvent("Please enter your last name"),
        );
        _showErrorSnackbar("Please enter your last name");
        return;
      }

      if (emailAddress.isEmpty) {
        context.read<SignUpBloc>().add(
          ErrorEvent("Please enter your email address"),
        );
        _showErrorSnackbar("Please enter your email address");
        return;
      }

      if (!_isValidEmail(emailAddress)) {
        context.read<SignUpBloc>().add(
          ErrorEvent("Please enter a valid email address"),
        );
        _showErrorSnackbar("Please enter a valid email address");
        return;
      }

      if (password.isEmpty) {
        context.read<SignUpBloc>().add(
          ErrorEvent("Please enter your password"),
        );
        _showErrorSnackbar("Please enter your password");
        return;
      }

      if (password.length < 6) {
        context.read<SignUpBloc>().add(
          ErrorEvent("Password must be at least 6 characters"),
        );
        _showErrorSnackbar("Password must be at least 6 characters");
        return;
      }

      if (confirmPassword.isEmpty) {
        context.read<SignUpBloc>().add(
          ErrorEvent("Please confirm your password"),
        );
        _showErrorSnackbar("Please confirm your password");
        return;
      }

      if (password != confirmPassword) {
        context.read<SignUpBloc>().add(ErrorEvent("Passwords do not match"));
        _showErrorSnackbar("Passwords do not match");
        return;
      }

      // Show loading
      context.read<SignUpBloc>().add(LoadingEvent(true));
      EasyLoading.show(
        status: 'Creating your account...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false,
      );

      try {
        // Create registration request entity
        RegisterRequestEntity registerRequestEntity = RegisterRequestEntity(
          username: emailAddress, // Use email as username for PHP API
          email: emailAddress,
          password: password,
          firstName: firstName,
          lastName: lastName,
        );

        // Call API registration
        var result = await UserAPI.register(params: registerRequestEntity);

        // Dismiss loading regardless of result
        EasyLoading.dismiss();
        context.read<SignUpBloc>().add(LoadingEvent(false));

        // Check PHP response format
        if (result.isSuccess) {
          // Registration successful
          await _handleSuccessfulRegistration(
            result,
            emailAddress,
            firstName,
            lastName,
          );
        } else {
          // Registration failed
          await _handleFailedRegistration(result);
        }
      } catch (e) {
        // Handle network or API errors
        await _handleRegistrationError(e);
      }
    } catch (e) {
      // Handle unexpected errors
      await _handleUnexpectedError(e);
    }
  }

  // Mock signup method (if you want to keep it as fallback)
  Future<void> handleMockSignUp() async {
    try {
      final state = context.read<SignUpBloc>().state;
      String emailAddress = state.email;
      String firstName = state.firstName;
      String lastName = state.lastName;

      // Show loading briefly
      EasyLoading.show(status: 'Creating account...');
      await Future.delayed(Duration(seconds: 1));
      EasyLoading.dismiss();

      toastInfo(msg: "Account created successfully!");

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SeedPhrasePage(
              email: emailAddress,
              firstName: firstName,
              lastName: lastName,
            ),
          ),
        );
      }
    } catch (e) {
      print("Mock signup error: $e");
      EasyLoading.dismiss();
      _showErrorSnackbar("Error creating account");
    }
  }

  Future<void> _handleSuccessfulRegistration(
    RegisterResponseEntity result,
    String email,
    String firstName,
    String lastName,
  ) async {
    try {
      // Save basic user data
      await _saveUserData(email, firstName, lastName);

      toastInfo(
        msg: result.report.isNotEmpty
            ? result.report
            : "Account created successfully!",
      );

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SeedPhrasePage(
              email: email,
              firstName: firstName,
              lastName: lastName,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error handling successful registration: ${e.toString()}');
      _showErrorSnackbar(
        "Account created but error saving data. Please sign in.",
      );

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.SIGN_IN);
      }
    }
  }

  Future<void> _handleFailedRegistration(RegisterResponseEntity result) async {
    String errorMessage = result.report.isNotEmpty
        ? result.report
        : "Registration failed. Please try again.";

    context.read<SignUpBloc>().add(ErrorEvent(errorMessage));

    // Show error toast
    toastInfo(msg: errorMessage);

    // Also show snackbar for better visibility
    _showErrorSnackbar(errorMessage);

    print('Registration failed: ${result.status} - ${result.report}');
  }

  Future<void> _handleRegistrationError(dynamic error) async {
    EasyLoading.dismiss();
    context.read<SignUpBloc>().add(LoadingEvent(false));

    String errorMessage =
        "Network error. Please check your connection and try again.";

    context.read<SignUpBloc>().add(ErrorEvent(errorMessage));

    // Show error to user
    _showErrorSnackbar(errorMessage);
    toastInfo(msg: errorMessage);

    print('Registration API error: ${error.toString()}');
  }

  Future<void> _handleUnexpectedError(dynamic error) async {
    EasyLoading.dismiss();
    context.read<SignUpBloc>().add(LoadingEvent(false));

    String errorMessage = "An unexpected error occurred. Please try again.";

    context.read<SignUpBloc>().add(ErrorEvent(errorMessage));

    _showErrorSnackbar(errorMessage);

    print('Unexpected signup error: ${error.toString()}');
  }

  bool _isValidEmail(String email) {
    try {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegex.hasMatch(email.trim());
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveUserData(
    String email,
    String firstName,
    String lastName,
  ) async {
    try {
      // Create basic user data
      Map<String, dynamic> userData = {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "username": email.split('@').first,
        "registration_time": DateTime.now().toIso8601String(),
      };

      // Save user profile
      await Global.storageService.setString(
        AppConstants.STORAGE_USER_PROFILE_KEY,
        jsonEncode(userData),
      );

      // Save a simple token
      await Global.storageService.setString(
        AppConstants.STORAGE_USER_TOKEN_KEY,
        "registered_${DateTime.now().millisecondsSinceEpoch}",
      );

      // Mark device as opened and user as registered
      await Global.storageService.setBool(
        AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME,
        true,
      );

      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: ${e.toString()}');
      throw Exception('Failed to save user data: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String message) {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              message,
              style: TextStyle(color: AppColors.primaryText),
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error showing snackbar: ${e.toString()}');
    }
  }

  // Utility method to clear form (optional)
  void clearForm() {
    context.read<SignUpBloc>().add(ErrorEvent(""));
    context.read<SignUpBloc>().add(LoadingEvent(false));
  }

  // Method to check if form is valid (for UI validation)
  bool isFormValid(SignUpState state) {
    return state.firstName.isNotEmpty &&
        state.lastName.isNotEmpty &&
        state.email.isNotEmpty &&
        _isValidEmail(state.email) &&
        state.password.isNotEmpty &&
        state.password.length >= 6 &&
        state.confirmPassword.isNotEmpty &&
        state.password == state.confirmPassword;
  }
}
