// dashboard_api.dart
import 'package:wal/common/entities/dashboard.dart';
import '../utils/http_util.dart';

class DashboardAPI {
  final HttpUtil httpUtil;

  DashboardAPI({required this.httpUtil});

  Future<DashboardResponse> getDashboardData() async {
    try {
      var response = await httpUtil.get('api/dashboard');

      return DashboardResponse.fromJson(response);
    } catch (e) {
      print('Dashboard API error: ${e.toString()}');
      rethrow;
    }
  }

  Future<DashboardResponse> getUserStats() async {
    try {
      var response = await httpUtil.get('api/user/stats');

      return DashboardResponse.fromJson(response);
    } catch (e) {
      print('User stats API error: ${e.toString()}');
      rethrow;
    }
  }
}
