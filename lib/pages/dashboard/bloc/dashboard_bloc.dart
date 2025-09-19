// lib/pages/dashboard/bloc/dashboard_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wal/common/apis/dashboard_api.dart';
import 'package:wal/pages/dashboard/bloc/dashboard_event.dart';
import 'package:wal/pages/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardAPI dashboardAPI;

  DashboardBloc({required this.dashboardAPI}) : super(const DashboardState()) {
    on<LoadDashboardData>(_loadDashboardData);
    on<RefreshDashboard>(_refreshDashboard);
    on<UserProfileUpdated>(_userProfileUpdated);
    on<DashboardError>(_dashboardError);
  }

  Future<void> _loadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    try {
      // For now, use mock data since your API might not be ready
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Mock data - replace with actual API call later
      final mockStats = [
        DashboardStat(
          title: 'Total Users',
          value: '1,234',
          icon: Icons.people,
          color: Colors.green,
        ),
        DashboardStat(
          title: 'Revenue',
          value: '\$12,345',
          icon: Icons.attach_money,
          color: Colors.blue,
        ),
      ];

      final mockActivities = [
        ActivityItem(
          title: 'New User Registered',
          description: 'John Doe joined the platform',
          time: DateTime.now().subtract(const Duration(hours: 1)),
          icon: Icons.person_add,
          color: Colors.green,
        ),
      ];

      emit(
        state.copyWith(
          isLoading: false,
          userData: null, // Set to actual user data when available
          stats: mockStats,
          recentActivities: mockActivities,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load dashboard data: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _refreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      // Similar to _loadDashboardData but without loading state
      await Future.delayed(const Duration(seconds: 1));

      final mockStats = [
        DashboardStat(
          title: 'Total Users',
          value: '1,245', // Updated value
          icon: Icons.people,
          color: Colors.green,
        ),
      ];

      emit(state.copyWith(stats: mockStats, errorMessage: ''));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Failed to refresh dashboard: ${e.toString()}',
        ),
      );
    }
  }

  void _userProfileUpdated(
    UserProfileUpdated event,
    Emitter<DashboardState> emit,
  ) {
    emit(state.copyWith(userData: event.userData));
  }

  void _dashboardError(DashboardError event, Emitter<DashboardState> emit) {
    emit(state.copyWith(errorMessage: event.errorMessage));
  }
}
