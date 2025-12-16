// sign_in_bloc.dart - CORRECTED & ENHANCED
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_event.dart';
import 'package:wal/pages/sign_in/bloc/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<UsernameEvent>(_onUsernameChanged);
    on<PasswordEvent>(_onPasswordChanged);
    on<LoadingEvent>(_onLoadingChanged);
    on<ErrorEvent>(_onErrorOccurred);
    on<SignInButtonPressedEvent>(_onSignInButtonPressed);
    on<ClearFormEvent>(_onClearForm);
    on<ValidateFormEvent>(_onValidateForm);
  }

  void _onUsernameChanged(UsernameEvent event, Emitter<SignInState> emit) {
    final newState = state.copyWith(
      username: event.username,
      error: "", // Clear any previous errors when user types
      usernameError: _validateUsername(event.username),
    );

    // Auto-validate form when username changes
    emit(newState.copyWith(isFormValid: _validateForm(newState)));
  }

  void _onPasswordChanged(PasswordEvent event, Emitter<SignInState> emit) {
    final newState = state.copyWith(
      password: event.password,
      error: "", // Clear any previous errors when user types
      passwordError: _validatePassword(event.password),
    );

    // Auto-validate form when password changes
    emit(newState.copyWith(isFormValid: _validateForm(newState)));
  }

  void _onLoadingChanged(LoadingEvent event, Emitter<SignInState> emit) {
    emit(
      state.copyWith(
        isLoading: event.isLoading,
        error: event.isLoading
            ? ""
            : state.error, // Clear error when loading starts
      ),
    );
  }

  void _onErrorOccurred(ErrorEvent event, Emitter<SignInState> emit) {
    emit(
      state.copyWith(
        error: event.error,
        isLoading: false, // Always stop loading on error
      ),
    );
  }

  void _onSignInButtonPressed(
    SignInButtonPressedEvent event,
    Emitter<SignInState> emit,
  ) {
    // Validate form before proceeding
    final usernameError = _validateUsername(state.username);
    final passwordError = _validatePassword(state.password);

    if (usernameError.isEmpty && passwordError.isEmpty) {
      emit(
        state.copyWith(
          isLoading: true,
          error: "",
          usernameError: "",
          passwordError: "",
        ),
      );
    } else {
      emit(
        state.copyWith(
          usernameError: usernameError,
          passwordError: passwordError,
          isFormValid: false,
        ),
      );
    }
  }

  void _onClearForm(ClearFormEvent event, Emitter<SignInState> emit) {
    emit(const SignInState()); // Reset to initial state
  }

  void _onValidateForm(ValidateFormEvent event, Emitter<SignInState> emit) {
    final usernameError = _validateUsername(state.username);
    final passwordError = _validatePassword(state.password);

    emit(
      state.copyWith(
        usernameError: usernameError,
        passwordError: passwordError,
        isFormValid: usernameError.isEmpty && passwordError.isEmpty,
      ),
    );
  }

  // Validation helper methods
  String _validateUsername(String username) {
    if (username.isEmpty) {
      return "Please enter your username";
    }
    if (username.length < 3) {
      return "Username must be at least 3 characters";
    }
    return "";
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return "Please enter your password";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return "";
  }

  bool _validateForm(SignInState state) {
    return state.username.isNotEmpty &&
        state.password.isNotEmpty &&
        state.password.length >= 6 &&
        state.username.length >= 3;
  }

  // Public methods that can be called from outside
  void setLoading(bool isLoading) {
    add(LoadingEvent(isLoading));
  }

  void setError(String error) {
    add(ErrorEvent(error));
  }

  void clearForm() {
    add(const ClearFormEvent());
  }

  void validateForm() {
    add(const ValidateFormEvent());
  }
}
