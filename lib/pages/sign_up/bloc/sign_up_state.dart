// sign_up_state.dart
class SignUpState {
  const SignUpState({
    this.email = "",
    this.password = "",
    this.confirmPassword = "",
    this.firstName = "",
    this.lastName = "",
  });

  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
