import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_event.dart';
import 'package:wal/pages/sign_up/bloc/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<EmailEvent>(_emailEvent);
    on<PasswordEvent>(_passwordEvent);
    on<ConfirmPasswordEvent>(_confirmPasswordEvent);
    on<FirstNameEvent>(_firstNameEvent);
    on<LastNameEvent>(_lastNameEvent);
    on<LoadingEvent>(_loadingEvent);
    on<ErrorEvent>(_errorEvent);
  }

  void _emailEvent(EmailEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email, error: ""));
  }

  void _passwordEvent(PasswordEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password, error: ""));
  }

  void _confirmPasswordEvent(
    ConfirmPasswordEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.confirmPassword, error: ""));
  }

  void _firstNameEvent(FirstNameEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(firstName: event.firstName, error: ""));
  }

  void _lastNameEvent(LastNameEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(lastName: event.lastName, error: ""));
  }

  void _loadingEvent(LoadingEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  void _errorEvent(ErrorEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(error: event.error, isLoading: false));
  }
}
