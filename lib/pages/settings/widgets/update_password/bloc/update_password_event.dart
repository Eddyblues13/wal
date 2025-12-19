// update_password_event.dart
abstract class UpdatePasswordEvent {
  const UpdatePasswordEvent();
}

class UpdatePasswordRequestEvent extends UpdatePasswordEvent {
  final String oldPassword;
  final String newPassword;
  const UpdatePasswordRequestEvent(this.oldPassword, this.newPassword);
}

class UpdatePasswordSuccessEvent extends UpdatePasswordEvent {
  final String message;
  const UpdatePasswordSuccessEvent(this.message);
}

class UpdatePasswordErrorEvent extends UpdatePasswordEvent {
  final String error;
  const UpdatePasswordErrorEvent(this.error);
}

class LoadingEvent extends UpdatePasswordEvent {
  final bool isLoading;
  const LoadingEvent(this.isLoading);
}

class ResetEvent extends UpdatePasswordEvent {
  const ResetEvent();
}

