// settings_state.dart
class SettingsState {
  const SettingsState({
    this.isLoading = false,
    this.error = "",
    this.userProfile,
    this.referralCode = "",
    this.isReferralCodeCopied = false,
    this.xLink = "",
    this.telegramLink = "",
    this.privacyPolicyUrl = "",
    this.termsOfServiceUrl = "",
    this.openSourceLicensesUrl = "",
  });

  final bool isLoading;
  final String error;
  final Map<String, dynamic>? userProfile;
  final String referralCode;
  final bool isReferralCodeCopied;
  final String xLink;
  final String telegramLink;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String openSourceLicensesUrl;

  SettingsState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? userProfile,
    String? referralCode,
    bool? isReferralCodeCopied,
    String? xLink,
    String? telegramLink,
    String? privacyPolicyUrl,
    String? termsOfServiceUrl,
    String? openSourceLicensesUrl,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userProfile: userProfile ?? this.userProfile,
      referralCode: referralCode ?? this.referralCode,
      isReferralCodeCopied: isReferralCodeCopied ?? this.isReferralCodeCopied,
      xLink: xLink ?? this.xLink,
      telegramLink: telegramLink ?? this.telegramLink,
      privacyPolicyUrl: privacyPolicyUrl ?? this.privacyPolicyUrl,
      termsOfServiceUrl: termsOfServiceUrl ?? this.termsOfServiceUrl,
      openSourceLicensesUrl: openSourceLicensesUrl ?? this.openSourceLicensesUrl,
    );
  }

  @override
  String toString() {
    return 'SettingsState{isLoading: $isLoading, error: $error, referralCode: $referralCode}';
  }
}

