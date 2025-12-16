import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'bloc/discover_bloc.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscoverBloc()..add(LoadDiscoverData()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'Discover',
            style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            return Column(
              children: [
                // Fixed search bar
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.muted.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(color: AppColors.primaryElementText),
                    decoration: InputDecoration(
                      hintText: "Search or enter dApp URL",
                      hintStyle: TextStyle(color: AppColors.muted),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.secondaryText,
                      ),
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured card
                        _buildFeaturedCard(),
                        SizedBox(height: 20.h),

                        // Tabs
                        _buildCategoryTabs(context, state.selectedTab),
                        SizedBox(height: 20.h),

                        // dApp List
                        _buildDAppSection(),
                        SizedBox(height: 24.h),

                        // Top tokens
                        _buildTopTokensSection(),

                        SizedBox(height: 40.h), // Extra bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stablecoin Earn",
                  style: TextStyle(
                    color: AppColors.primaryElementText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Grow your stablecoins in-app with secure staking",
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Start →",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, int selectedTab) {
    final categories = ['Featured', 'DEX', 'BSC', 'Solana', 'Yield'];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, index) => SizedBox(width: 16.w),
        itemBuilder: (_, index) {
          return _buildCategoryTab(
            context,
            categories[index],
            index,
            selectedTab,
          );
        },
      ),
    );
  }

  Widget _buildCategoryTab(
    BuildContext context,
    String label,
    int index,
    int selectedTab,
  ) {
    final isSelected = index == selectedTab;

    return GestureDetector(
      onTap: () => context.read<DiscoverBloc>().add(ChangeDiscoverTab(index)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.chipSelectedBg : AppColors.card,
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected
              ? Border.all(color: AppColors.chipSelectedText.withOpacity(0.3))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.chipSelectedText
                : AppColors.secondaryText,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDAppSection() {
    final dApps = [
      {
        'name': 'Aave',
        'desc': 'Open Source and Non-Custodial protocol to earn...',
      },
      {
        'name': 'Lido Staking',
        'desc': 'The Lido Ethereum Liquid Staking Protocol...',
      },
      {'name': 'dYdX', 'desc': 'Decentralization with deep liquidity...'},
      {
        'name': 'Uniswap',
        'desc': 'Swap, earn, and build on decentralized crypto...',
      },
      {
        'name': 'Pendle',
        'desc': 'Protocol that enables the trading of tokens...',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Popular dApps",
          style: TextStyle(
            color: AppColors.primaryElementText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Column(
          children: dApps.map((dApp) {
            return _buildDAppItem(
              dApp['name'] as String,
              dApp['desc'] as String,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDAppItem(String name, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.purpleBadge.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.apps, color: AppColors.purpleBadge, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.primaryElementText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.secondaryText,
            size: 16.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildTopTokensSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top dApp tokens",
          style: TextStyle(
            color: AppColors.primaryElementText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildTokenCard(
                "Trust Wallet",
                "TWT",
                "\$1.25",
                "-13.80%",
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTokenCard("Bitcoin", "BTC", "\$65,000", "+2.30%"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTokenCard(
    String name,
    String symbol,
    String price,
    String change,
  ) {
    final isNegative = change.contains("-");

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            symbol,
            style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            price,
            style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            change,
            style: TextStyle(
              color: isNegative ? Colors.redAccent : AppColors.primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
