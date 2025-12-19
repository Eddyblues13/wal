import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wal/common/entities/user.dart';
import 'package:wal/common/values/constant.dart';

class StorageService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  bool getDeviceFirstOpen() {
    return _prefs.getBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME) ?? false;
  }

  bool getIsLoggedIn() {
    return _prefs.getString(AppConstants.STORAGE_USER_TOKEN_KEY) == null
        ? false
        : true;
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  String getUserToken() {
    return _prefs.getString(AppConstants.STORAGE_USER_TOKEN_KEY) ?? "";
  }

  UserItem getUserProfile() {
    var profileOffline =
        _prefs.getString(AppConstants.STORAGE_USER_PROFILE_KEY) ?? "";
    if (profileOffline.isNotEmpty) {
      return UserItem.fromJson(jsonDecode(profileOffline));
    }
    return UserItem();
  }

  String getUserMnemonic() {
    return _prefs.getString('user_mnemonic') ?? "";
  }

  String getUserWallet() {
    final wallet = _prefs.getString('user_wallet') ?? "";
    print('🔍 STORAGE - Retrieved wallet: "$wallet"');
    print('🔍 STORAGE - Wallet is empty: ${wallet.isEmpty}');
    return wallet;
  }

  Future<bool> setUserWallet(String wallet, String mnemonic) async {
    print('💾 STORAGE - Saving wallet: $wallet');
    await _prefs.setString('user_wallet', wallet);
    final result = await _prefs.setString('user_mnemonic', mnemonic);
    print('✅ STORAGE - Wallet saved successfully');
    return result;
  }

  // Add this method to debug all storage contents
  void debugStorage() {
    print('=== STORAGE DEBUG ===');
    print(
      'User Token: ${_prefs.getString(AppConstants.STORAGE_USER_TOKEN_KEY) ?? "NOT SET"}',
    );
    print('User Wallet: ${_prefs.getString('user_wallet') ?? "NOT SET"}');
    print(
      'User Profile: ${_prefs.getString(AppConstants.STORAGE_USER_PROFILE_KEY) ?? "NOT SET"}',
    );
    print('=====================');
  }
}
