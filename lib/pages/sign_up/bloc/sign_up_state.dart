class SignUpState {
  const SignUpState({
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
    this.firstName = "",
    this.lastName = "",
    this.isLoading = false,
    this.error = "",
  });

  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final bool isLoading;
  final String error;

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    bool? isLoading,
    String? error,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
