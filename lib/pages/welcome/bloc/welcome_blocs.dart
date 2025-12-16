import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/welcome/bloc/welcome_events.dart';
import 'package:wal/pages/welcome/bloc/welcome_states.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeState()) {
    on<WelcomeEvent>((event, emit) {
      emit(WelcomeState(page: event.page ?? state.page));
    });
  }
}
