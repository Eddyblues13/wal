abstract class HistoryEvent {
  const HistoryEvent();
}

class HistoryLoadData extends HistoryEvent {
  const HistoryLoadData();
}

class HistoryRefreshData extends HistoryEvent {
  const HistoryRefreshData();
}

class HistoryNetworkChanged extends HistoryEvent {
  final String network;
  const HistoryNetworkChanged(this.network);
}
