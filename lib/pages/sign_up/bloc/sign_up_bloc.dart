// sign_up_bloc.dart
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
  }

  void _emailEvent(EmailEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordEvent(PasswordEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _confirmPasswordEvent(ConfirmPasswordEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _firstNameEvent(FirstNameEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(firstName: event.firstName));
  }

  void _lastNameEvent(LastNameEvent event, Emitter<SignUpState> emit) {
    emit(state.copyWith(lastName: event.lastName));
  }
}