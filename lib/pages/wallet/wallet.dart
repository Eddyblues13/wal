import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/entities/wallet.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/common/service/wallet_service.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/wallet/bloc/wallet_bloc.dart';
import 'package:wal/pages/wallet/bloc/wallet_event.dart';
import 'package:wal/pages/wallet/bloc/wallet_state.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late List<CryptoAsset> trendingAssets = [];
  late List<CryptoAsset> userCryptoAssets = [];
  late List<NFTAsset> userNFTs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    trendingAssets = await WalletService.getTrendingAssets();
    userCryptoAssets = await WalletService.getUserCryptoAssets();
    userNFTs = await WalletService.getUserNFTs();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryText,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainWalletHeader(),
                    SizedBox(height: 20.h),
                    _buildMainWallet(state),
                    SizedBox(height: 24.h),
                    _buildWalletActions(context),
                    SizedBox(height: 24.h),
                    _buildTrendingSection(),
                    SizedBox(height: 24.h),
                    _buildCategoryTabs(state.selectedTab),
                    SizedBox(height: 16.h),
                    state.selectedTab == 'Crypto'
                        ? _buildCryptoView(context, userCryptoAssets)
                        : _buildNFTView(context, userNFTs),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _bottomNavigationBar(state.bottomNavIndex),
        );
      },
    );
  }

  Widget _buildMainWalletHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Row(
              children: [
                Icon(Icons.history, size: 20.sp, color: Colors.black),
                SizedBox(width: 10.w),
                Icon(Icons.qr_code_scanner, size: 20.sp, color: Colors.black),
              ],
            ),
            SizedBox(width: 50.w),
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      'Main Wallet 1',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      top: -4.w,
                      right: -8.w,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2.w),
                Icon(Icons.arrow_drop_down, size: 20.sp, color: Colors.black),
              ],
            ),
          ],
        ),
        Icon(Icons.search, size: 24.sp, color: Colors.black),
      ],
    );
  }

  Widget _buildMainWallet(WalletState state) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '\$${state.balance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${state.portfolioValue.toStringAsFixed(2)} (${state.portfolioChange.toStringAsFixed(2)}%)',
            style: TextStyle(
              fontSize: 14.sp,
              color: state.portfolioChange >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionsItem(Icons.arrow_upward, 'Send'),
        _buildActionsItem(Icons.copy, 'Receive'),
        _buildActionsItem(
          Icons.flash_on,
          'Buy',
          isActive: true,
          onTap: () {
            context.read<WalletBloc>().add(const WalletBuyCrypto());
          },
        ),
        _buildActionsItem(Icons.account_balance, 'Sell'),
      ],
    );
  }

  Widget _buildActionsItem(
    IconData icon,
    String label, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: isActive ? Colors.blue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.primaryText : Colors.black,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Trending',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 90.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 16.w),
            physics: const BouncingScrollPhysics(),
            children: trendingAssets
                .map((asset) => _buildTrendingCard(asset))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard(CryptoAsset asset) {
    final changeColor = asset.change24h >= 0 ? Colors.green : Colors.red;
    final changeSign = asset.change24h >= 0 ? '+' : '';

    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.primaryText,
                child: Icon(Icons.currency_bitcoin, size: 20.sp),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 8.r,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.link,
                    size: 10.sp,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  asset.symbol,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$${(asset.marketCap / 1000000000).toStringAsFixed(2)}B',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$${asset.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '$changeSign${asset.change24h.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 12.sp, color: changeColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(String selectedTab) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 46.h,
      child: Row(
        children: [
          _buildTab("Crypto", selectedTab),
          SizedBox(width: 20.w),
          _buildTab("NFTs", selectedTab),
          const Spacer(),
          Icon(Icons.tune, color: Colors.grey, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String selectedTab) {
    bool isActive = selectedTab == label;
    return GestureDetector(
      onTap: () => context.read<WalletBloc>().add(WalletTabChanged(label)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 4.h),
              height: 4.h,
              width: 24.w,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }

  Widget _buildCryptoView(BuildContext context, List<CryptoAsset> assets) {
    if (assets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your wallet is empty.",
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<WalletBloc>().add(const WalletBuyCrypto());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                  horizontal: 120.w,
                  vertical: 10.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r),
                ),
              ),
              child: Text(
                "Buy Crypto",
                style: TextStyle(fontSize: 16.sp, color: AppColors.primaryText),
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                context.read<WalletBloc>().add(const WalletDepositCrypto());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                padding: EdgeInsets.symmetric(
                  horizontal: 110.w,
                  vertical: 10.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r),
                ),
              ),
              child: Text(
                "Deposit Crypto",
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () {
                context.read<WalletBloc>().add(const WalletManageCrypto());
              },
              child: Text(
                "Manage crypto",
                style: TextStyle(color: Colors.blue, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: assets.map((asset) => _buildCryptoAssetCard(asset)).toList(),
    );
  }

  Widget _buildCryptoAssetCard(CryptoAsset asset) {
    final changeColor = asset.change24h >= 0 ? Colors.green : Colors.red;
    final changeSign = asset.change24h >= 0 ? '+' : '';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(Icons.currency_bitcoin, color: Colors.blue),
      ),
      title: Text(
        asset.name,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      subtitle: Text(
        '${asset.amount} ${asset.symbol}',
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${asset.value.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            '$changeSign${asset.change24h.toStringAsFixed(2)}%',
            style: TextStyle(color: changeColor, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildNFTView(BuildContext context, List<NFTAsset> nfts) {
    if (nfts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.crop_square, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                "No NFTs yet. Purchased or received NFTs will show up here.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () {
                context.read<WalletBloc>().add(const WalletReceiveNFTs());
              },
              child: Text(
                "Receive NFTs",
                style: TextStyle(color: Colors.blue, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.8,
      ),
      itemCount: nfts.length,
      itemBuilder: (context, index) {
        final nft = nfts[index];
        return _buildNFTCard(nft);
      },
    );
  }

  Widget _buildNFTCard(NFTAsset nft) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: Icon(Icons.image, size: 40.sp, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nft.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  nft.collection,
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Floor: \$${nft.floorPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 10.sp, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(int bottomNavIndex) {
    List<Map<String, dynamic>> items = [
      {'icon': Icons.home, 'label': 'Home', 'route': AppRoutes.HOME},
      {
        'icon': Icons.show_chart,
        'label': 'Trending',
        'route': AppRoutes.TRENDING,
      },
      {'icon': Icons.swap_horiz, 'label': 'Swap', 'route': AppRoutes.SWAP},
      {'icon': Icons.diamond, 'label': 'Earn', 'route': AppRoutes.EARN},
      {'icon': Icons.explore, 'label': 'Discover', 'route': AppRoutes.DISCOVER},
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      height: 70.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = bottomNavIndex == index;
          return GestureDetector(
            onTap: () {
              context.read<WalletBloc>().add(WalletNavIndexChanged(index));
              Navigator.of(context).pushNamed(item['route']);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item['icon'],
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                SizedBox(height: 4.h),
                Text(
                  item['label'],
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey,
                    fontSize: 12.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
