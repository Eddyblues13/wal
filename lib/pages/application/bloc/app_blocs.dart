import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/pages/application/bloc/app_events.dart';
import 'package:wal/pages/application/bloc/app_states.dart';

class AppBlocs extends Bloc<AppEvent, AppState> {
  AppBlocs() : super(const AppState()) {
    on<TriggerAppEvent>((event, emit) {
      emit(AppState(index: event.index));
    });
  }
}
