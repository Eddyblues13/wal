// sign_up_controller.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wal/common/apis/user_api.dart';
import 'package:wal/common/entities/user.dart';
import 'package:wal/common/values/constant.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/global.dart' show Global;
import 'package:wal/pages/sign_up/bloc/sign_up_bloc.dart';

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

      // Validation
      if (emailAddress.isEmpty) {
        toastInfo(msg: "You need to fill email address");
        return;
      }
      if (password.isEmpty) {
        toastInfo(msg: "You need to fill password");
        return;
      }
      if (confirmPassword.isEmpty) {
        toastInfo(msg: "You need to confirm your password");
        return;
      }
      if (password != confirmPassword) {
        toastInfo(msg: "Passwords do not match");
        return;
      }
      if (firstName.isEmpty) {
        toastInfo(msg: "You need to fill first name");
        return;
      }
      if (lastName.isEmpty) {
        toastInfo(msg: "You need to fill last name");
        return;
      }
      if (password.length < 6) {
        toastInfo(msg: "Password must be at least 6 characters");
        return;
      }

      try {
        // Create registration request entity
        RegisterRequestEntity registerRequestEntity = RegisterRequestEntity(
          email: emailAddress,
          password: password,
          firstName: firstName,
          lastName: lastName,
          name: '$firstName $lastName', // Combine first and last name
        );

        // Call API registration
        await asyncPostRegistrationData(registerRequestEntity);
      } catch (e) {
        print('Registration error: ${e.toString()}');
        toastInfo(msg: "Registration failed. Please try again.");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> asyncPostRegistrationData(
    RegisterRequestEntity registerRequestEntity,
  ) async {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    try {
      var result = await UserAPI.register(params: registerRequestEntity);

      if (result.code == 200 || result.code == 201) {
        try {
          // Store user data
          Global.storageService.setString(
            AppConstants.STORAGE_USER_PROFILE_KEY,
            jsonEncode(result.data!),
          );

          // Store the access token
          Global.storageService.setString(
            AppConstants.STORAGE_USER_TOKEN_KEY,
            result.data!.access_token!,
          );

          EasyLoading.dismiss();
          toastInfo(msg: "Registration successful!");

          if (context.mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil("/application", (route) => false);
          }
        } catch (e) {
          print("Saving local storage error ${e.toString()}");
          EasyLoading.dismiss();
          toastInfo(msg: "Error saving user data");
        }
      } else {
        EasyLoading.dismiss();
        toastInfo(msg: result.msg ?? "Registration failed");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("API call error: ${e.toString()}");
      toastInfo(msg: "Network error. Please try again.");
    }
  }
}
