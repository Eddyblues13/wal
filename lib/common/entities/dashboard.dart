// lib/common/entities/dashboard.dart
import 'package:wal/common/entities/user.dart';

class DashboardResponse {
  final int code;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      code: json['code'] ?? 200,
      message: json['message'] ?? '',
      data: DashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardData {
  final UserItem user;
  final List<DashboardStat> stats;
  final List<ActivityItem> activities;

  DashboardData({
    required this.user,
    required this.stats,
    required this.activities,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      user: UserItem.fromJson(json['user'] ?? {}),
      stats: (json['stats'] as List? ?? []).map((e) => DashboardStat.fromJson(e)).toList(),
      activities: (json['activities'] as List? ?? []).map((e) => ActivityItem.fromJson(e)).toList(),
    );
  }
}

class DashboardStat {
  final String title;
  final String value;
  final String icon;
  final String color;

  DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  factory DashboardStat.fromJson(Map<String, dynamic> json) {
    return DashboardStat(
      title: json['title'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#000000',
    );
  }
}

class ActivityItem {
  final String title;
  final String description;
  final String time;
  final String icon;
  final String color;

  ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#000000',
    );
  }
}