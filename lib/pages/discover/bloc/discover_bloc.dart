import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class DiscoverEvent {}

class LoadDiscoverData extends DiscoverEvent {}

class ChangeDiscoverTab extends DiscoverEvent {
  final int index;
  ChangeDiscoverTab(this.index);
}

// State
class DiscoverState {
  final int selectedTab;
  final bool isLoading;

  DiscoverState({this.selectedTab = 0, this.isLoading = false});

  DiscoverState copyWith({int? selectedTab, bool? isLoading}) {
    return DiscoverState(
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Bloc
class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc() : super(DiscoverState()) {
    on<LoadDiscoverData>(_onLoadDiscoverData);
    on<ChangeDiscoverTab>(_onChangeDiscoverTab);
  }

  void _onLoadDiscoverData(
    LoadDiscoverData event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1)); // mock API delay
    emit(state.copyWith(isLoading: false));
  }

  void _onChangeDiscoverTab(
    ChangeDiscoverTab event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.index));
  }
}
