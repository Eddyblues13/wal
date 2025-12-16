// lib/pages/asset_selection_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';

class AssetSelectionPage extends StatefulWidget {
  const AssetSelectionPage({super.key});

  @override
  State<AssetSelectionPage> createState() => _AssetSelectionPageState();
}

class _AssetSelectionPageState extends State<AssetSelectionPage> {
  final List<Map<String, dynamic>> _assets = [
    {'symbol': 'LTC', 'name': 'Litecoin', 'network': 'Litecoin'},
    {'symbol': 'TRX', 'name': 'Tron', 'network': 'Tron'},
    {'symbol': 'BTC', 'name': 'Bitcoin', 'network': 'Bitcoin'},
    {'symbol': 'ETH', 'name': 'Ethereum', 'network': 'Ethereum'},
    {'symbol': 'BNB', 'name': 'BNB', 'network': 'BNB Beacon Chain'},
    {'symbol': 'TWT', 'name': 'Trust Wallet', 'network': 'BNB Smart Chain'},
    {'symbol': 'USDT', 'name': 'USDT', 'network': 'Tron'},
    {'symbol': 'USDT', 'name': 'USDT', 'network': 'Ethereum'},
    {'symbol': 'BNB', 'name': 'BNB', 'network': 'BNB Smart Chain'},
    {'symbol': 'NEON', 'name': 'NEON', 'network': 'Neon'},
    {'symbol': 'STARS', 'name': 'STARS', 'network': 'Stargaze'},
    {'symbol': 'SEI', 'name': 'SEI', 'network': 'Sei'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                        Icons.close,
                        size: 18.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Select Asset',
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  Icon(Icons.arrow_drop_down, color: AppColors.secondaryText),
                ],
              ),
            ),
            // Assets List
            Expanded(
              child: ListView.builder(
                itemCount: _assets.length,
                itemBuilder: (context, index) {
                  final asset = _assets[index];
                  return _buildAssetItem(asset);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetItem(Map<String, dynamic> asset) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: () {
          // Handle asset selection
          Navigator.pop(context, asset);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                child: Text(
                  asset['symbol'],
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
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
                    Text(
                      asset['name'],
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
