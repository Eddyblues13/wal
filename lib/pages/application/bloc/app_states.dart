class AppState {
  const AppState({this.index = 0, this.isLoading = false});

  final int index;
  final bool isLoading;

  AppState copyWith({int? index, bool? isLoading}) {
    return AppState(
      index: index ?? this.index,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
