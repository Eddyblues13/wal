import 'package:flutter/widgets.dart';
import 'package:wal/common/entities/dashboard.dart';
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