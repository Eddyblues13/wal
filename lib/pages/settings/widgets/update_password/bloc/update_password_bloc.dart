// update_password_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/settings/widgets/update_password/bloc/update_password_event.dart';
import 'package:wal/pages/settings/widgets/update_password/bloc/update_password_state.dart';

class UpdatePasswordBloc extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  UpdatePasswordBloc() : super(const UpdatePasswordState()) {
    on<UpdatePasswordRequestEvent>(_onUpdatePasswordRequest);
    on<UpdatePasswordSuccessEvent>(_onUpdatePasswordSuccess);
    on<UpdatePasswordErrorEvent>(_onUpdatePasswordError);
    on<LoadingEvent>(_onLoadingChanged);
    on<ResetEvent>(_onReset);
  }

  void _onUpdatePasswordRequest(
    UpdatePasswordRequestEvent event,
    Emitter<UpdatePasswordState> emit,
  ) {
    emit(state.copyWith(isLoading: true, error: "", success: false, message: ""));
  }

  void _onUpdatePasswordSuccess(
    UpdatePasswordSuccessEvent event,
    Emitter<UpdatePasswordState> emit,
  ) {
    emit(state.copyWith(
      isLoading: false,
      success: true,
      message: event.message,
      error: "",
    ));
  }

  void _onUpdatePasswordError(
    UpdatePasswordErrorEvent event,
    Emitter<UpdatePasswordState> emit,
  ) {
    emit(state.copyWith(
      isLoading: false,
      success: false,
      error: event.error,
      message: "",
    ));
  }

  void _onLoadingChanged(
    LoadingEvent event,
    Emitter<UpdatePasswordState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _onReset(
    ResetEvent event,
    Emitter<UpdatePasswordState> emit,
  ) {
    emit(const UpdatePasswordState());
  }

  // Public methods
  void setLoading(bool isLoading) {
    add(LoadingEvent(isLoading));
  }

  void setSuccess(String message) {
    add(UpdatePasswordSuccessEvent(message));
  }

  void setError(String error) {
    add(UpdatePasswordErrorEvent(error));
  }

  void reset() {
    add(const ResetEvent());
  }
}

