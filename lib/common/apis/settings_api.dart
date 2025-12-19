// lib/common/apis/settings_api.dart
import 'dart:convert';
import '../entities/settings.dart';
import '../utils/http_util.dart';

class SettingsAPI {
  // Get settings data (user profile, referral code, social links, etc.)
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<SettingsDataResponseEntity> getSettingsData(
    String walletAddress,
  ) async {
    try {
      print('⚙️ Fetching settings data for wallet: $walletAddress');

      var response = await HttpUtil().post(
        'settings_data.php',
        mydata: {
          'wallet': walletAddress,
        },
      );

      print('📥 Raw settings data response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse settings response: $e');
          return _getDefaultSettingsData();
        }
      } else {
        return _getDefaultSettingsData();
      }

      // Check if response has error
      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultSettingsData();
      }

      try {
        return SettingsDataResponseEntity.fromJson(responseData);
      } catch (e) {
        print('❌ Failed to parse settings entity: $e');
        return _getDefaultSettingsData();
      }
    } catch (e) {
      print('💥 Settings data API exception: $e');
      return _getDefaultSettingsData();
    }
  }

  // Get about page links (Privacy Policy, Terms of Service, Open Source Licenses)
  // Note: Wallet address is required - backend uses it to identify the user
  static Future<AboutLinksResponseEntity> getAboutLinks(
    String walletAddress,
  ) async {
    try {
      print('📄 Fetching about page links for wallet: $walletAddress');

      var response = await HttpUtil().post(
        'about_links.php',
        mydata: {
          'wallet': walletAddress,
        },
      );

      print('📥 Raw about links response: $response');

      Map<String, dynamic> responseData = {};

      if (response is Map<String, dynamic>) {
        responseData = response;
      } else if (response is String) {
        try {
          responseData = jsonDecode(response) as Map<String, dynamic>;
        } catch (e) {
          print('❌ Failed to parse about links response: $e');
          return _getDefaultAboutLinks();
        }
      } else {
        return _getDefaultAboutLinks();
      }

      // Check if response has error
      if (responseData.containsKey('error') ||
          responseData['status'] == 'error') {
        print('⚠️ API returned error, using default data');
        return _getDefaultAboutLinks();
      }

      try {
        return AboutLinksResponseEntity.fromJson(responseData);
      } catch (e) {
        print('❌ Failed to parse about links entity: $e');
        return _getDefaultAboutLinks();
      }
    } catch (e) {
      print('💥 About links API exception: $e');
      return _getDefaultAboutLinks();
    }
  }

  // Default settings data when API fails
  static SettingsDataResponseEntity _getDefaultSettingsData() {
    print('📋 Using default settings data');

    return SettingsDataResponseEntity(
      success: true,
      message: 'Using default settings data',
      userProfile: {
        'name': 'User',
        'email': 'user@example.com',
        'wallet': '',
      },
      referralCode: 'REF123456',
      xLink: 'https://twitter.com/starwallet',
      telegramLink: 'https://t.me/starwallet',
    );
  }

  // Default about links when API fails
  static AboutLinksResponseEntity _getDefaultAboutLinks() {
    print('📋 Using default about links');

    return AboutLinksResponseEntity(
      success: true,
      message: 'Using default about links',
      privacyPolicyUrl: 'https://starwallet.com/privacy-policy',
      termsOfServiceUrl: 'https://starwallet.com/terms-of-service',
      openSourceLicensesUrl: 'https://starwallet.com/open-source-licenses',
    );
  }
}

