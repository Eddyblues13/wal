class SignInState {
  const SignInState({
    this.email = "",
    this.password = "",
    this.isLoading = false,
  });

  final String email;
  final String password;
  final bool isLoading;

  SignInState copyWith({
    String? email,
    String? password,
    bool? isLoading,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
