// settings_event.dart
abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadSettingsDataEvent extends SettingsEvent {
  const LoadSettingsDataEvent();
}

class RefreshSettingsDataEvent extends SettingsEvent {
  const RefreshSettingsDataEvent();
}

class CopyReferralCodeEvent extends SettingsEvent {
  const CopyReferralCodeEvent();
}

class UpdateUserProfileEvent extends SettingsEvent {
  final Map<String, dynamic> userProfile;
  const UpdateUserProfileEvent(this.userProfile);
}

class LoadAboutLinksEvent extends SettingsEvent {
  const LoadAboutLinksEvent();
}

class LoadingEvent extends SettingsEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ErrorEvent extends SettingsEvent {
  final String error;
  const ErrorEvent(this.error);
}

