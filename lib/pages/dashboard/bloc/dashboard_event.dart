// dashboard_event.dart
import 'package:wal/common/entities/user.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}

class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

class UserProfileUpdated extends DashboardEvent {
  final UserItem userData;
  const UserProfileUpdated(this.userData);
}

class DashboardError extends DashboardEvent {
  final String errorMessage;
  const DashboardError(this.errorMessage);
}
