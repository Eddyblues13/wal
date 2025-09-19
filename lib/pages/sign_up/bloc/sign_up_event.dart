// sign_up_event.dart
abstract class SignUpEvent {
  const SignUpEvent();
}

class EmailEvent extends SignUpEvent {
  final String email;
  const EmailEvent(this.email);
}

class PasswordEvent extends SignUpEvent {
  final String password;
  const PasswordEvent(this.password);
}

class ConfirmPasswordEvent extends SignUpEvent {
  final String confirmPassword;
  const ConfirmPasswordEvent(this.confirmPassword);
}

class FirstNameEvent extends SignUpEvent {
  final String firstName;
  const FirstNameEvent(this.firstName);
}

class LastNameEvent extends SignUpEvent {
  final String lastName;
  const LastNameEvent(this.lastName);
}
