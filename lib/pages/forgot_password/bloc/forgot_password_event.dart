abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPasswordEmailEvent extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordEmailEvent(this.email);
}

class LoadingEvent extends ForgotPasswordEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ErrorEvent extends ForgotPasswordEvent {
  final String error;
  const ErrorEvent(this.error);
}
