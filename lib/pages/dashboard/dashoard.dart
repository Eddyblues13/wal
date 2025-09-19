import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:wal/pages/dashboard/bloc/dashboard_event.dart';
import 'package:wal/pages/dashboard/bloc/dashboard_state.dart';
import 'package:wal/pages/dashboard/dashboard_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = DashboardController(context: context);
      _controller.initDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(state),
          body: buildBody(state),
          floatingActionButton: buildFloatingActionButton(),
        );
      },
    );
  }

  AppBar buildAppBar(DashboardState state) {
    return AppBar(
      title: Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _controller.refreshDashboard(),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _handleLogout(),
        ),
      ],
    );
  }

  Widget buildBody(DashboardState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage,
              style: TextStyle(fontSize: 16.sp, color: Colors.red),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: _controller.refreshDashboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _controller.refreshDashboard(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildWelcomeSection(state),
            SizedBox(height: 24.h),
            buildStatsGrid(state),
            SizedBox(height: 24.h),
            buildRecentActivities(state),
            SizedBox(height: 24.h),
            buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeSection(DashboardState state) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundImage: state.userData?.avatar != null
                  ? NetworkImage(state.userData!.avatar!)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
              child: state.userData?.avatar == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${state.userData?.name ?? 'User'}!',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    state.userData?.email ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget buildStatsGrid(DashboardState state) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.2,
    ),
    itemCount: state.stats.length,
    itemBuilder: (context, index) {
      final stat = state.stats[index];
      final color = _parseColor(stat.color);
      final icon = _getIconData(stat.icon);
      
      return Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30.r, color: Colors.white),
              SizedBox(height: 8.h),
              Text(
                stat.value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                stat.title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildRecentActivities(DashboardState state) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ...state.recentActivities.map((activity) {
            final color = _parseColor(activity.color);
            final icon = _getIconData(activity.icon);
            
            return ListTile(
              leading: Icon(icon, color: color),
              title: Text(activity.title),
              subtitle: Text(activity.description),
              trailing: Text(
                activity.time,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            );
          }),
        ],
      ),
    ),
  );
}

// Helper methods to convert string to Color and IconData
Color _parseColor(String colorString) {
  try {
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    }
    return Colors.blue; // default color
  } catch (e) {
    return Colors.blue;
  }
}

IconData _getIconData(String iconName) {
  switch (iconName) {
    case 'people':
      return Icons.people;
    case 'attach_money':
      return Icons.attach_money;
    case 'person_add':
      return Icons.person_add;
    case 'settings':
      return Icons.settings;
    case 'history':
      return Icons.history;
    case 'help':
      return Icons.help;
    default:
      return Icons.info;
  }
}
  Widget buildQuickActions() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                _buildActionButton(Icons.person, 'Profile', () {}),
                _buildActionButton(Icons.settings, 'Settings', () {}),
                _buildActionButton(Icons.history, 'History', () {}),
                _buildActionButton(Icons.help, 'Help', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18.r),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
      backgroundColor: Colors.blue,
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _handleLogout() {
    // Implement logout logic
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
  }
}