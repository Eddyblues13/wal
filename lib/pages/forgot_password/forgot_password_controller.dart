import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wal/common/apis/user_api.dart';
import 'package:wal/common/entities/user.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_event.dart';

class ForgotPasswordController {
  final BuildContext context;

  const ForgotPasswordController({required this.context});

  Future<void> handleForgotPassword() async {
    try {
      final state = context.read<ForgotPasswordBloc>().state;
      String emailAddress = state.email;

      // Clear previous errors
      context.read<ForgotPasswordBloc>().add(ErrorEvent(""));

      // Validation
      if (emailAddress.isEmpty) {
        context.read<ForgotPasswordBloc>().add(
          ErrorEvent("Please enter your email address"),
        );
        _showErrorSnackbar("Please enter your email address");
        return;
      }

      if (!_isValidEmail(emailAddress)) {
        context.read<ForgotPasswordBloc>().add(
          ErrorEvent("Please enter a valid email address"),
        );
        _showErrorSnackbar("Please enter a valid email address");
        return;
      }

      // Show loading
      context.read<ForgotPasswordBloc>().add(LoadingEvent(true));
      EasyLoading.show(
        status: 'Sending reset link...',
        maskType: EasyLoadingMaskType.black,
      );

      try {
        // Create forgot password request entity
        ForgotPasswordRequestEntity forgotPasswordRequestEntity =
            ForgotPasswordRequestEntity(email: emailAddress);

        // Call API for forgot password
        var result = await UserAPI.forgotPassword(
          params: forgotPasswordRequestEntity,
        );

        EasyLoading.dismiss();
        context.read<ForgotPasswordBloc>().add(LoadingEvent(false));

        // Check PHP response format
        if (result.isSuccess) {
          // Success - show message from API or default
          String successMessage = result.report.isNotEmpty
              ? result.report
              : "Password reset link sent to your email";

          toastInfo(msg: successMessage);
          _showSuccessSnackbar(successMessage);

          // Navigate back after successful submission
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          // Error - show message from API or default
          String errorMessage = result.report.isNotEmpty
              ? result.report
              : "Password reset failed. Please try again.";

          context.read<ForgotPasswordBloc>().add(ErrorEvent(errorMessage));
          _showErrorSnackbar(errorMessage);
          toastInfo(msg: errorMessage);
        }
      } catch (e) {
        EasyLoading.dismiss();
        context.read<ForgotPasswordBloc>().add(LoadingEvent(false));

        String errorMessage =
            "Network error. Please check your connection and try again.";
        context.read<ForgotPasswordBloc>().add(ErrorEvent(errorMessage));
        _showErrorSnackbar(errorMessage);

        print('Forgot password API error: ${e.toString()}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      context.read<ForgotPasswordBloc>().add(LoadingEvent(false));
      _showErrorSnackbar("An unexpected error occurred");
      print('ForgotPassword controller error: ${e.toString()}');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _showErrorSnackbar(String message) {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(message, style: TextStyle(color: Colors.white)),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error showing error snackbar: ${e.toString()}');
    }
  }

  void _showSuccessSnackbar(String message) {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(message, style: TextStyle(color: Colors.white)),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error showing success snackbar: ${e.toString()}');
    }
  }

  // Utility method to clear form
  void clearForm() {
    context.read<ForgotPasswordBloc>().add(ErrorEvent(""));
    context.read<ForgotPasswordBloc>().add(LoadingEvent(false));
  }
}
