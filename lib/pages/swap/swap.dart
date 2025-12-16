import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'bloc/swap_bloc.dart';

class SwapPage extends StatelessWidget {
  const SwapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SwapBloc(),
      child: BlocBuilder<SwapBloc, int>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Swap',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: _buildSwapBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildSwapBody(BuildContext context, int state) {
    return SafeArea(
      child: Column(
        children: [
          // Main content that can scroll
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Swap Card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.muted.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildSwapInput(
                          context,
                          'From',
                          'STAR',
                          'STAR',
                          '0.00',
                          Icons.account_balance_wallet_outlined,
                        ),

                        // Swap arrow button
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          child: Icon(
                            Icons.swap_vert,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                        ),

                        _buildSwapInput(
                          context,
                          'To',
                          'USDT',
                          'Tether USD',
                          '0.00',
                          Icons.currency_exchange_outlined,
                        ),

                        SizedBox(height: 16.h),

                        // Price info
                        _buildPriceInfo(),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Swap details
                  _buildSwapDetails(),

                  SizedBox(height: 20.h),

                  // Recent Swaps title
                  Row(
                    children: [
                      Text(
                        'Recent Swaps',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Recent Swaps List
                  _buildRecentSwapsList(),

                  SizedBox(height: 20.h), // Extra bottom padding
                ],
              ),
            ),
          ),

          // Fixed bottom button section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border(
                top: BorderSide(
                  color: AppColors.muted.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _showSwapConfirmation(context);
                },
                child: Text(
                  'Swap Now',
                  style: TextStyle(
                    fontSize: 16.sp,
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

  Widget _buildSwapInput(
    BuildContext context,
    String label,
    String symbol,
    String name,
    String amount,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.secondaryText, fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              // Token selector
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.arrowBox,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: AppColors.primaryColor, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      symbol,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.secondaryText,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Price',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 12.sp),
          ),
          Text(
            '1 TAP = 0.17 USDT',
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwapDetails() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildDetailRow('Network Fee', '\$1.20'),
          SizedBox(height: 8.h),
          _buildDetailRow('Price Impact', '0.3%', isPositive: true),
          SizedBox(height: 8.h),
          _buildDetailRow('Minimum Received', '99.4 USDT'),
          SizedBox(height: 8.h),
          _buildDetailRow('Route', 'TAP → USDT', showInfo: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isPositive = false,
    bool showInfo = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 12.sp),
        ),
        if (showInfo) ...[
          SizedBox(width: 4.w),
          Icon(Icons.info_outline, color: AppColors.muted, size: 14.sp),
        ],
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isPositive ? AppColors.primaryColor : AppColors.primaryText,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSwapsList() {
    final recentSwaps = [
      {'from': 'STAR', 'to': 'USDT', 'amount': '100', 'value': '\$17.00'},
      {'from': 'TON', 'to': 'USDT', 'amount': '5', 'value': '\$25.00'},
      {'from': 'USDT', 'to': 'STAR', 'amount': '50', 'value': '\$8.50'},
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recentSwaps.length,
      separatorBuilder: (_, index) =>
          Divider(height: 1.h, color: AppColors.muted.withOpacity(0.2)),
      itemBuilder: (_, index) {
        final swap = recentSwaps[index];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              // Token pair icons
              Stack(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.purpleBadge.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        swap['from']!.substring(0, 1),
                        style: TextStyle(
                          color: AppColors.purpleBadge,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          swap['to']!.substring(0, 1),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${swap['from']} → ${swap['to']}',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${(index + 1) * 10} mins ago',
                      style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${swap['amount']} ${swap['from']}',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    swap['value']!,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSwapConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Confirm Swap',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildConfirmationRow('From', '100 STAR', '\$17.00'),
            SizedBox(height: 8.h),
            _buildConfirmationRow('To', '17 USDT', '\$17.00'),
            SizedBox(height: 12.h),
            _buildConfirmationRow('Network Fee', '\$1.20', '', isFee: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.background,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.primaryColor,
                  content: Text(
                    'Swap executed successfully!',
                    style: TextStyle(color: AppColors.background),
                  ),
                ),
              );
            },
            child: Text('Confirm Swap'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(
    String label,
    String value,
    String amount, {
    bool isFee = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 14.sp),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: isFee ? AppColors.muted : AppColors.primaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (amount.isNotEmpty)
              Text(
                amount,
                style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
              ),
          ],
        ),
      ],
    );
  }
}
