class ForgotPasswordState {
  const ForgotPasswordState({
    this.email = "",
    this.isLoading = false,
    this.error = "",
  });

  final String email;
  final bool isLoading;
  final String error;

  ForgotPasswordState copyWith({
    String? email,
    bool? isLoading,
    String? error,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
