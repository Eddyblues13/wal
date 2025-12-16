// lib/pages/receive_crypto_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/home/bloc/home_bloc.dart';
import 'package:wal/pages/home/bloc/home_state.dart';

class ReceiveCryptoPage extends StatelessWidget {
  const ReceiveCryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        // Hardcoded crypto assets
        final cryptoAssets = [
          {'symbol': 'USDT', 'name': 'Tether USD', 'network': 'TRC20'},
          {'symbol': 'TAPCOIN', 'name': 'STAR', 'network': 'BEP20'},
          {'symbol': 'TON', 'name': 'Toncoin', 'network': 'TON Network'},
        ];

        final popularAssets = cryptoAssets.take(2).toList(); // First 2
        final allAssets = cryptoAssets;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: AppColors.iconBackground,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Receive',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 36.w),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.secondaryText,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: AppColors.secondaryText),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                    ),
                  ),
                ),

                // Network Filter
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'All Networks',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.secondaryText,
                      ),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Popular
                        Text(
                          'Popular',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ...popularAssets.map(
                          (asset) => _buildAssetItem(context, asset),
                        ),
                        SizedBox(height: 24.h),
                        // Divider
                        Container(height: 1.h, color: AppColors.divider),
                        SizedBox(height: 24.h),
                        // All Crypto
                        Text(
                          'All crypto',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ...allAssets.map(
                          (asset) => _buildAssetItem(context, asset),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssetItem(BuildContext context, Map<String, dynamic> asset) {
    // Generate fake address based on symbol
    String generateAddress(String symbol) {
      final baseAddresses = {
        'USDT': 'TXXR4k21AhzP2xTYYRbWzz8PhQ2Hq9Q1yt',
        'TAPCOIN': '0x8aF32Bf94eA8c26A06D567b90271B71267fF7A1D',
        'TON': 'EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx',
      };
      return baseAddresses[symbol] ?? '${symbol}_address_123456';
    }

    final address = generateAddress(asset['symbol']);
    final shortenedAddress =
        '${address.substring(0, 10)}...${address.substring(address.length - 8)}';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showReceiveAddressPage(context, asset, address);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    asset['symbol'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset['symbol'],
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        asset['network'],
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  shortenedAddress,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReceiveAddressPage(
    BuildContext context,
    Map<String, dynamic> asset,
    String address,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ReceiveAddressPage(asset: asset, address: address);
      },
    );
  }
}

class ReceiveAddressPage extends StatelessWidget {
  final Map<String, dynamic> asset;
  final String address;

  const ReceiveAddressPage({
    super.key,
    required this.asset,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Receive',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppColors.secondaryText,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
          // Warning
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Only send ${asset['name']} (${asset['symbol']}) assets to this address. Other assets will be lost forever.',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Asset Info
          Text(
            asset['symbol'],
            style: TextStyle(
              color: AppColors.primaryText,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            asset['name'],
            style: TextStyle(color: AppColors.secondaryText, fontSize: 14.sp),
          ),
          SizedBox(height: 24.h),

          // QR Placeholder
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              color: AppColors.primaryText,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                Icons.qr_code_2,
                size: 80.sp,
                color: AppColors.background,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Address
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              address,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),

          // Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryText,
                      side: BorderSide(color: AppColors.secondaryText),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text('Copy'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryText,
                      side: BorderSide(color: AppColors.secondaryText),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text('Set Amount'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryText,
                      side: BorderSide(color: AppColors.secondaryText),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text('Share'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Deposit Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deposit from exchange',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'By direct transfer from your account',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
