import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'bloc/trending_bloc.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrendingBloc(),
      child: BlocBuilder<TrendingBloc, int>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text(
                'Trending Tokens',
                style: TextStyle(
                  color: AppColors.primaryElementText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: _buildTrendingBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildTrendingBody(BuildContext context, int state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // Filter section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time filter
              _buildTimeFilter(),
              SizedBox(height: 12.h),

              // Chain filters
              _buildChainFilters(context, state),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // Table header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Token',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Volume',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Price Change',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Trending tokens list
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 15,
            separatorBuilder: (_, index) =>
                Divider(height: 1.h, color: AppColors.muted.withOpacity(0.2)),
            itemBuilder: (_, index) {
              return _buildTokenItem(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '24H',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primaryElementText,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.secondaryText,
            size: 18.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildChainFilters(BuildContext context, int selectedIndex) {
    final chains = ['All Chains', 'Ethereum', 'BNB Chain', 'Solana', 'Polygon'];

    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chains.length,
        separatorBuilder: (_, index) => SizedBox(width: 8.w),
        itemBuilder: (_, index) {
          return _buildChainChip(context, chains[index], index, selectedIndex);
        },
      ),
    );
  }

  Widget _buildChainChip(
    BuildContext context,
    String label,
    int index,
    int selectedIndex,
  ) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        context.read<TrendingBloc>().updateIndex(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.chipSelectedBg : AppColors.card,
          border: Border.all(
            color: isSelected
                ? AppColors.chipSelectedText.withOpacity(0.3)
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isSelected
                ? AppColors.chipSelectedText
                : AppColors.secondaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTokenItem(int index) {
    final isPositive = index % 3 != 0; // Mix of positive and negative changes
    final changePercent = isPositive ? 12.3 + index : -4.5 - (index % 2);
    final volume = 100.23 + (index * 25.67);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // Rank number
          Container(
            width: 24.w,
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Token icon
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: _getTokenColor(index),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'T${index + 1}',
                style: TextStyle(
                  color: AppColors.primaryElementText,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Token info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Token ${index + 1}',
                  style: TextStyle(
                    color: AppColors.primaryElementText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'TKN${index + 1}',
                  style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                ),
              ],
            ),
          ),

          // Volume
          Expanded(
            flex: 2,
            child: Text(
              '\$${volume.toStringAsFixed(1)}M',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Price change
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.chipSelectedBg.withOpacity(0.3)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '${changePercent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive
                        ? AppColors.chipSelectedText
                        : Colors.redAccent,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTokenColor(int index) {
    final colors = [
      AppColors.primaryColor,
      AppColors.purpleBadge,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
    ];
    return colors[index % colors.length];
  }
}
