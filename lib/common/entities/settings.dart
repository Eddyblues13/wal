// lib/common/entities/settings.dart

// Settings Data Response Entity
// Note: Wallet is not included - backend identifies user from authentication token/session
class SettingsDataResponseEntity {
  final bool success;
  final String message;
  final String? error;
  final Map<String, dynamic>? userProfile;
  final String referralCode;
  final String xLink;
  final String telegramLink;

  SettingsDataResponseEntity({
    required this.success,
    required this.message,
    this.error,
    this.userProfile,
    required this.referralCode,
    required this.xLink,
    required this.telegramLink,
  });

  factory SettingsDataResponseEntity.fromJson(Map<String, dynamic> json) =>
      SettingsDataResponseEntity(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        error: json["error"]?.toString(),
        userProfile: json["userProfile"] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json["userProfile"])
            : null,
        referralCode: json["referralCode"]?.toString() ?? "",
        xLink: json["xLink"]?.toString() ?? "",
        telegramLink: json["telegramLink"]?.toString() ?? "",
      );

  bool get isSuccess => success;
}

// About Page Links Response Entity
class AboutLinksResponseEntity {
  final bool success;
  final String message;
  final String? error;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String openSourceLicensesUrl;

  AboutLinksResponseEntity({
    required this.success,
    required this.message,
    this.error,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.openSourceLicensesUrl,
  });

  factory AboutLinksResponseEntity.fromJson(Map<String, dynamic> json) =>
      AboutLinksResponseEntity(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        error: json["error"]?.toString(),
        privacyPolicyUrl: json["privacy_policy_url"]?.toString() ?? "",
        termsOfServiceUrl: json["terms_of_service_url"]?.toString() ?? "",
        openSourceLicensesUrl: json["open_source_licenses_url"]?.toString() ?? "",
      );

  bool get isSuccess => success;
}

