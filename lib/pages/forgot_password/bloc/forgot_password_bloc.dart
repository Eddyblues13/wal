import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_event.dart';
import 'package:wal/pages/forgot_password/bloc/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailEvent>(_emailEvent);
    on<LoadingEvent>(_loadingEvent);
    on<ErrorEvent>(_errorEvent);
  }

  void _emailEvent(
    ForgotPasswordEmailEvent event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(email: event.email, error: ""));
  }

  void _loadingEvent(LoadingEvent event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _errorEvent(ErrorEvent event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(error: event.error, isLoading: false));
  }
}
