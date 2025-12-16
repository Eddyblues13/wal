// sign_in_event.dart - CORRECTED & ENHANCED
abstract class SignInEvent {
  const SignInEvent();
}

class UsernameEvent extends SignInEvent {
  final String username;
  const UsernameEvent(this.username);
}

class PasswordEvent extends SignInEvent {
  final String password;
  const PasswordEvent(this.password);
}

class LoadingEvent extends SignInEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ErrorEvent extends SignInEvent {
  final String error;
  const ErrorEvent(this.error);
}

// NEW: Event to trigger the actual sign-in process
class SignInButtonPressedEvent extends SignInEvent {
  const SignInButtonPressedEvent();
}

// NEW: Event to clear form and errors
class ClearFormEvent extends SignInEvent {
  const ClearFormEvent();
}

// NEW: Event to validate form
class ValidateFormEvent extends SignInEvent {
  const ValidateFormEvent();
}
