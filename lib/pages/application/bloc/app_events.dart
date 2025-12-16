abstract class AppEvent {
  const AppEvent();
}

class TriggerAppEvent extends AppEvent {
  final int index;
  const TriggerAppEvent(this.index) : super();
}

class AppLoadingEvent extends AppEvent {
  final bool isLoading;
  const AppLoadingEvent(this.isLoading);
}
