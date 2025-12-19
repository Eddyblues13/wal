// update_password_state.dart
class UpdatePasswordState {
  const UpdatePasswordState({
    this.isLoading = false,
    this.error = "",
    this.success = false,
    this.message = "",
  });

  final bool isLoading;
  final String error;
  final bool success;
  final String message;

  UpdatePasswordState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
    String? message,
  }) {
    return UpdatePasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'UpdatePasswordState{isLoading: $isLoading, error: $error, success: $success, message: $message}';
  }
}

