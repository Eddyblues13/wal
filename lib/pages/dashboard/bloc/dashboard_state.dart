// dashboard_state.dart
import 'package:flutter/widgets.dart';
import 'package:wal/common/entities/user.dart';

class DashboardState {
  const DashboardState({
    this.isLoading = true,
    this.userData,
    this.stats = const [],
    this.recentActivities = const [],
    this.errorMessage = '',
  });

  final bool isLoading;
  final UserItem? userData;
  final List<DashboardStat> stats;
  final List<ActivityItem> recentActivities;
  final String errorMessage;

  DashboardState copyWith({
    bool? isLoading,
    UserItem? userData,
    List<DashboardStat>? stats,
    List<ActivityItem>? recentActivities,
    String? errorMessage,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      userData: userData ?? this.userData,
      stats: stats ?? this.stats,
      recentActivities: recentActivities ?? this.recentActivities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DashboardStat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class ActivityItem {
  final String title;
  final String description;
  final DateTime time;
  final IconData icon;
  final Color color;

  const ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
}