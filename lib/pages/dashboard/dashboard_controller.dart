// dashboard_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wal/common/apis/dashboard_api.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:wal/pages/dashboard/bloc/dashboard_event.dart';

class DashboardController {
  final BuildContext context;

  const DashboardController({required this.context});

  Future<void> initDashboard() async {
    try {
      EasyLoading.show(status: 'Loading dashboard...');

      // Load dashboard data
      context.read<DashboardBloc>().add(const LoadDashboardData());

      // Simulate loading time or wait for actual data
      await Future.delayed(const Duration(seconds: 1));

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print('Dashboard initialization error: ${e.toString()}');
    }
  }

  Future<void> refreshDashboard() async {
    try {
      context.read<DashboardBloc>().add(const RefreshDashboard());
    } catch (e) {
      print('Dashboard refresh error: ${e.toString()}');
      toastInfo(msg: 'Failed to refresh dashboard');
    }
  }

  void handleError(String errorMessage) {
    context.read<DashboardBloc>().add(DashboardError(errorMessage));
    toastInfo(msg: errorMessage);
  }

  void updateUserProfile(dynamic userData) {
    // Convert to UserItem if needed
    context.read<DashboardBloc>().add(UserProfileUpdated(userData));
  }
}
