// sign_in_state.dart - CORRECTED & ENHANCED
class SignInState {
  const SignInState({
    this.username = "",
    this.password = "",
    this.isLoading = false,
    this.error = "",
    this.isFormValid = false,
    this.usernameError = "",
    this.passwordError = "",
  });

  final String username;
  final String password;
  final bool isLoading;
  final String error;
  final bool isFormValid;
  final String usernameError;
  final String passwordError;

  SignInState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    String? error,
    bool? isFormValid,
    String? usernameError,
    String? passwordError,
  }) {
    return SignInState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isFormValid: isFormValid ?? this.isFormValid,
      usernameError: usernameError ?? this.usernameError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  // Helper method to check if form can be submitted
  bool get canSubmit =>
      username.isNotEmpty &&
      password.isNotEmpty &&
      password.length >= 6 &&
      !isLoading;

  @override
  String toString() {
    return 'SignInState{username: $username, password: ${'*' * password.length}, isLoading: $isLoading, error: $error, isFormValid: $isFormValid}';
  }
}
