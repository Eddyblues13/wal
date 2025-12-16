import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/application/bloc/app_blocs.dart';
import 'package:wal/pages/application/bloc/app_events.dart';
import 'package:wal/pages/application/bloc/app_states.dart';
import 'package:wal/pages/application/widgets/application_widgets.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({Key? key}) : super(key: key);

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBlocs, AppState>(
      builder: (context, state) {
        return Container(
          color: AppColors.background,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: buildPage(state.index),
              bottomNavigationBar: Container(
                width: 375.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.muted.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_filled, 'Home', 0, state.index),
                    _buildNavItem(Icons.swap_horiz, 'Swap', 1, state.index),
                    _buildNavItem(Icons.auto_graph, 'Stake', 2, state.index),
                    _buildNavItem(Icons.settings, 'Settings', 3, state.index),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    int currentIndex,
  ) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        context.read<AppBlocs>().add(TriggerAppEvent(index));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.secondaryText,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.secondaryText,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
