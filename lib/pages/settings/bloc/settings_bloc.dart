// settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/settings/bloc/settings_event.dart';
import 'package:wal/pages/settings/bloc/settings_state.dart';

// Internal event for setting settings data
class _SetSettingsDataEvent extends SettingsEvent {
  final Map<String, dynamic>? userProfile;
  final String referralCode;
  final String xLink;
  final String telegramLink;
  
  const _SetSettingsDataEvent(
    this.userProfile,
    this.referralCode,
    this.xLink,
    this.telegramLink,
  );
}

// Internal event for setting about links
class _SetAboutLinksEvent extends SettingsEvent {
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String openSourceLicensesUrl;
  
  const _SetAboutLinksEvent(
    this.privacyPolicyUrl,
    this.termsOfServiceUrl,
    this.openSourceLicensesUrl,
  );
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettingsDataEvent>(_onLoadSettingsData);
    on<RefreshSettingsDataEvent>(_onRefreshSettingsData);
    on<CopyReferralCodeEvent>(_onCopyReferralCode);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<LoadAboutLinksEvent>(_onLoadAboutLinks);
    on<LoadingEvent>(_onLoadingChanged);
    on<ErrorEvent>(_onErrorOccurred);
    on<_SetSettingsDataEvent>(_onSetSettingsData);
    on<_SetAboutLinksEvent>(_onSetAboutLinks);
  }

  void _onSetSettingsData(
    _SetSettingsDataEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      userProfile: event.userProfile,
      referralCode: event.referralCode,
      xLink: event.xLink,
      telegramLink: event.telegramLink,
      isLoading: false,
      error: "",
    ));
  }

  void _onSetAboutLinks(
    _SetAboutLinksEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      privacyPolicyUrl: event.privacyPolicyUrl,
      termsOfServiceUrl: event.termsOfServiceUrl,
      openSourceLicensesUrl: event.openSourceLicensesUrl,
      isLoading: false,
      error: "",
    ));
  }

  void _onLoadAboutLinks(
    LoadAboutLinksEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onLoadSettingsData(
    LoadSettingsDataEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onRefreshSettingsData(
    RefreshSettingsDataEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: ""));
  }

  void _onCopyReferralCode(
    CopyReferralCodeEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isReferralCodeCopied: true));
    
    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) {
        emit(state.copyWith(isReferralCodeCopied: false));
      }
    });
  }

  void _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(userProfile: event.userProfile));
  }

  void _onLoadingChanged(
    LoadingEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onErrorOccurred(
    ErrorEvent event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      error: event.error,
      isLoading: false,
    ));
  }

  // Public methods
  void setSettingsData(
    Map<String, dynamic>? userProfile,
    String referralCode,
    String xLink,
    String telegramLink,
  ) {
    add(_SetSettingsDataEvent(userProfile, referralCode, xLink, telegramLink));
  }

  void setAboutLinks(
    String privacyPolicyUrl,
    String termsOfServiceUrl,
    String openSourceLicensesUrl,
  ) {
    add(_SetAboutLinksEvent(
      privacyPolicyUrl,
      termsOfServiceUrl,
      openSourceLicensesUrl,
    ));
  }

  void setLoading(bool isLoading) {
    add(LoadingEvent(isLoading));
  }

  void setError(String error) {
    add(ErrorEvent(error));
  }
}

