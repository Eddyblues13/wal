// sign_in_controller.dart
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
import 'package:wal/pages/sign_in/bloc/sign_in_bloc.dart';

class SignInController {
  final BuildContext context;

  const SignInController({required this.context});

  Future<void> handleSignIn(String type) async {
    try {
      if (type == "email") {
        final state = context.read<SignInBloc>().state;
        String emailAddress = state.email;
        String password = state.password;
        
        if (emailAddress.isEmpty) {
          toastInfo(msg: "You need to fill email address");
          return;
        }
        if (password.isEmpty) {
          toastInfo(msg: "You need to fill password");
          return;
        }
        
        try {
          // Create login request entity
          LoginRequestEntity loginRequestEntity = LoginRequestEntity();
          loginRequestEntity.email = emailAddress;
          loginRequestEntity.password = password; // Add password field
          
          // Call API login directly
          await asyncPostAllData(loginRequestEntity);
          
        } catch (e) {
          print('Login error: ${e.toString()}');
          toastInfo(msg: "Login failed. Please try again.");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true
    );
    
    try {
      var result = await UserAPI.login(params: loginRequestEntity);
      
      if(result.code == 200){
        try {
          Global.storageService.setString(
            AppConstants.STORAGE_USER_PROFILE_KEY, 
            jsonEncode(result.data!)
          );
          
          // Store the access token
          Global.storageService.setString(
            AppConstants.STORAGE_USER_TOKEN_KEY, 
            result.data!.access_token!
          );
          
          EasyLoading.dismiss();
          
          if(context.mounted){
            Navigator.of(context).pushNamedAndRemoveUntil(
              "/application", 
              (route) => false
            );
          }
        } catch(e) {
          print("Saving local storage error ${e.toString()}");
          EasyLoading.dismiss();
          toastInfo(msg: "Error saving user data");
        }
      } else {
        EasyLoading.dismiss();
        toastInfo(msg: result.msg ?? "Login failed");
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("API call error: ${e.toString()}");
      toastInfo(msg: "Network error. Please try again.");
    }
  }
}