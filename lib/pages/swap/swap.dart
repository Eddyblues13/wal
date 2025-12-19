// lib/pages/swap/swap.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/swap/bloc/swap_bloc.dart';
import 'package:wal/pages/swap/bloc/swap_event.dart';
import 'package:wal/pages/swap/bloc/swap_state.dart';
import 'package:wal/pages/swap/swap_controller.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SwapBloc(),
      child: Builder(
        builder: (blocContext) {
          // Load swap data once when bloc is available
          if (!_hasInitialized) {
            _hasInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                SwapController(context: blocContext).loadSwapData();
              }
            });
          }
          
          return BlocBuilder<SwapBloc, SwapState>(
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
                body: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      )
                    : _buildSwapBody(context, state),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSwapBody(BuildContext context, SwapState state) {
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
                          state,
                          'From',
                          state.fromAsset?['symbol'] ?? 'STAR',
                          state.fromAsset?['name'] ?? 'STAR',
                          state.fromAmount,
                          Icons.account_balance_wallet_outlined,
                          true,
                        ),

                        // Swap arrow button
                        GestureDetector(
                          onTap: () {
                            context.read<SwapBloc>().add(const SwapTokensEvent());
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            child: Icon(
                              Icons.swap_vert,
                              color: AppColors.primaryColor,
                              size: 24.sp,
                            ),
                          ),
                        ),

                        _buildSwapInput(
                          context,
                          state,
                          'To',
                          state.toAsset?['symbol'] ?? 'USDT',
                          state.toAsset?['name'] ?? 'Tether USD',
                          state.toAmount,
                          Icons.currency_exchange_outlined,
                          false,
                        ),

                        SizedBox(height: 16.h),

                        // Price info
                        _buildPriceInfo(state),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Swap details
                  _buildSwapDetails(state),

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
                  _buildRecentSwapsList(state),

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
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _showComingSoonDialog(context);
                },
                child: Text(
                  'Swap Now',
                  style: TextStyle(
                    color: Colors.white,
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
    SwapState state,
    String label,
    String symbol,
    String name,
    String amount,
    IconData icon,
    bool isFrom,
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
              GestureDetector(
                onTap: () {
                  _showAssetSelector(context, state, isFrom);
                },
                child: Container(
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
              ),
              const Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '0.00',
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(SwapState state) {
    final fromSymbol = state.fromAsset?['symbol'] ?? 'STAR';
    final toSymbol = state.toAsset?['symbol'] ?? 'USDT';
    
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
            '1 $fromSymbol = 0.00 $toSymbol',
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

  Widget _buildSwapDetails(SwapState state) {
    final toSymbol = state.toAsset?['symbol'] ?? 'USDT';
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildDetailRow('Network Fee', state.networkFee),
          SizedBox(height: 8.h),
          _buildDetailRow('Price Impact', state.priceImpact, isPositive: true),
          SizedBox(height: 8.h),
          _buildDetailRow('Minimum Received', '${state.minimumReceived} $toSymbol'),
          SizedBox(height: 8.h),
          _buildDetailRow('Route', state.route, showInfo: true),
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

  Widget _buildRecentSwapsList(SwapState state) {
    final recentSwaps = state.recentSwaps;

    if (recentSwaps.isEmpty) {
      return const SizedBox.shrink();
    }

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
                        (swap['from'] ?? '').toString().substring(0, 1),
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
                          (swap['to'] ?? '').toString().substring(0, 1),
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
                      swap['time'] ?? '${(index + 1) * 10} mins ago',
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
                    swap['value'] ?? '',
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

  void _showAssetSelector(BuildContext context, SwapState state, bool isFrom) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select ${isFrom ? 'From' : 'To'} Asset',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              ...state.availableAssets.map((asset) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: Text(
                      asset['symbol'] ?? '',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    asset['symbol'] ?? '',
                    style: TextStyle(color: AppColors.primaryText),
                  ),
                  subtitle: Text(
                    asset['name'] ?? '',
                    style: TextStyle(color: AppColors.secondaryText),
                  ),
                  onTap: () {
                    if (isFrom) {
                      context.read<SwapBloc>().add(SelectFromAssetEvent(asset));
                    } else {
                      context.read<SwapBloc>().add(SelectToAssetEvent(asset));
                    }
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Coming Soon',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'The swap feature is coming soon. Stay tuned for updates!',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16.sp,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}
