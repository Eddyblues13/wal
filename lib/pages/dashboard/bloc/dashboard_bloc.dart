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
      final response = await dashboardAPI.getDashboardData();
      
      if (response.code == 200) {
        emit(
          state.copyWith(
            isLoading: false,
            userData: response.data.user,
            stats: response.data.stats,
            recentActivities: response.data.activities,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: response.message,
          ),
        );
      }
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
      final response = await dashboardAPI.getDashboardData();
      
      if (response.code == 200) {
        emit(
          state.copyWith(
            userData: response.data.user,
            stats: response.data.stats,
            recentActivities: response.data.activities,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: response.message,
          ),
        );
      }
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