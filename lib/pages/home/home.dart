import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/common/utils/crypto_image_util.dart';
import 'package:wal/global.dart';
import 'package:wal/pages/home/bloc/home_bloc.dart';
import 'package:wal/pages/home/bloc/home_event.dart';
import 'package:wal/pages/home/bloc/home_state.dart';
import 'package:wal/pages/home/home_controller.dart';
import 'package:wal/pages/home/dialog/historyPage.dart';
import 'package:wal/pages/receive/receive_crypto_page.dart';
import 'package:wal/pages/send/send_crypto_page.dart';
import 'package:wal/pages/settings/settings_page.dart';
import 'package:wal/pages/swap/swap_crypto_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();

    // Debug storage before loading data
    print('🏠 Home Screen - Initializing...');
    Global.storageService.debugStorage();
  }

  void _showSendCryptoPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SendCryptoPage()),
    );
  }

  void _showReceiveCryptoPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReceiveCryptoPage()),
    );
  }

  void _showSwapCryptoPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SwapCryptoPage()),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error, style: TextStyle(fontSize: 14.sp)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Builder(
        builder: (blocContext) {
          // Load home data once when bloc is available
          if (!_hasInitialized) {
            _hasInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                HomeController(context: blocContext).loadHomeData();
              }
            });
          }

          return BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              // Show error snackbar when API error occurs
              if (state.apiError.isNotEmpty) {
                _showErrorSnackBar(context, state.apiError);
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            // Refresh data when pull-to-refresh
                            HomeController(
                              context: blocContext,
                            ).refreshHomeData();
                            await Future.delayed(const Duration(seconds: 1));
                          },
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMainWalletHeader(context, state),
                                SizedBox(height: 20.h),
                                _buildMainWallet(state),
                                SizedBox(height: 24.h),
                                _buildWalletActions(context),
                                SizedBox(height: 24.h),
                                _buildCryptoView(context, state),
                                SizedBox(height: 24.h),
                                _buildRecentTransactions(context, state),
                                SizedBox(height: 24.h),
                                // _buildWalletInfo(state),
                                // SizedBox(height: 40.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Refresh floating action button
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    HomeController(context: blocContext).refreshHomeData();
                  },
                  backgroundColor: AppColors.primaryColor,
                  mini: true,
                  child: Icon(
                    state.isLoading ? Icons.hourglass_top : Icons.refresh,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainWalletHeader(BuildContext context, HomeState state) {
    final walletAddress = state.walletAddress;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.history,
                size: 22.sp,
                color: AppColors.secondaryText,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
            ),
            SizedBox(width: 8.w),
            IconButton(
              icon: Icon(
                Icons.qr_code_scanner,
                size: 22.sp,
                color: AppColors.secondaryText,
              ),
              onPressed: () {
                // Show wallet QR code
                if (walletAddress.isNotEmpty) {
                  _showWalletQrCode(context, walletAddress);
                } else {
                  _showErrorSnackBar(context, 'Wallet address not available');
                }
              },
            ),
          ],
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        //   decoration: BoxDecoration(
        //     color: AppColors.card,
        //     borderRadius: BorderRadius.circular(20.r),
        //   ),
        //   child: GestureDetector(
        //     onTap: () => showWalletsDialog(context),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.account_balance_wallet,
        //           size: 16.sp,
        //           color: AppColors.primaryColor,
        //         ),
        //         SizedBox(width: 6.w),
        //         Text(
        //           walletAddress.isNotEmpty ? 'Main Wallet' : 'Demo Wallet',
        //           style: TextStyle(
        //             fontSize: 14.sp,
        //             fontWeight: FontWeight.w500,
        //             color: AppColors.primaryText,
        //           ),
        //         ),
        //         SizedBox(width: 4.w),
        //         Icon(
        //           Icons.arrow_drop_down,
        //           size: 18.sp,
        //           color: AppColors.secondaryText,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        IconButton(
          icon: Icon(
            Icons.settings,
            size: 24.sp,
            color: AppColors.secondaryText,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainWallet(HomeState state) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (state.isLoading) ...[
            SizedBox(
              width: 120.w,
              height: 40.h,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              '\$${state.balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  state.portfolioChange >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  size: 14.sp,
                  color: state.portfolioChange >= 0
                      ? AppColors.primaryColor
                      : Colors.redAccent,
                ),
                SizedBox(width: 4.w),
                Text(
                  '\$${state.portfolioValue.toStringAsFixed(2)} (${state.portfolioChange >= 0 ? '+' : ''}${state.portfolioChange.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: state.portfolioChange >= 0
                        ? AppColors.primaryColor
                        : Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (state.walletAddress.isNotEmpty) ...[
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => _copyToClipboard(context, state.walletAddress),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.copy,
                      size: 12.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _getShortWalletAddress(state.walletAddress),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWalletActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionsItem(
          Icons.arrow_upward,
          'Send',
          onTap: () {
            context.read<HomeBloc>().add(const HomeSendCrypto());
            _showSendCryptoPage(context);
          },
        ),
        _buildActionsItem(
          Icons.arrow_downward,
          'Receive',
          isActive: true,
          onTap: () {
            context.read<HomeBloc>().add(const HomeReceiveCrypto());
            _showReceiveCryptoPage(context);
          },
        ),
        _buildActionsItem(
          Icons.currency_exchange,
          'Swap',
          onTap: () {
            context.read<HomeBloc>().add(const HomeSwapCrypto());
            _showSwapCryptoPage(context);
          },
        ),
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
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryColor : AppColors.card,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isActive
                    ? AppColors.primaryColor
                    : AppColors.muted.withOpacity(0.3),
                width: isActive ? 2 : 1.5,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : AppColors.secondaryText,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoView(BuildContext context, HomeState state) {
    if (state.isLoading && state.cryptoAssets.isEmpty) {
      return _buildLoadingAssets();
    }

    if (state.cryptoAssets.isEmpty) {
      return _buildEmptyAssets();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Text(
            'My Assets',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: state.cryptoAssets
              .map((asset) => _buildCryptoAssetCard(asset))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLoadingAssets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Text(
            'My Assets',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.muted.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: AppColors.muted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 60.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: AppColors.muted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 70.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: AppColors.muted.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 50.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.muted.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyAssets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Text(
            'My Assets',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 48.sp,
                color: AppColors.muted,
              ),
              SizedBox(height: 16.h),
              Text(
                'No Assets Found',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your wallet assets will appear here',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () {
                  context.read<HomeBloc>().add(const HomeRefreshData());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Refresh',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoAssetCard(Map<String, dynamic> asset) {
    bool isPositive = (asset['change'] as String).contains('+');
    double balance = (asset['balance'] as num?)?.toDouble() ?? 0.0;

    // Only show assets with balance > 0
    if (balance <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.muted.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAssetIcon(asset),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset['name'] ?? 'Unknown Asset',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  asset['amount'] ?? '0',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                asset['value'] ?? '\$0.00',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                asset['change'] ?? '+0.00%',
                style: TextStyle(
                  color: isPositive ? AppColors.primaryColor : Colors.redAccent,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetIcon(Map<String, dynamic> asset) {
    final iconUrl = asset['icon'];
    final symbol = asset['symbol'] ?? '?';

    // Get online image URL
    final imageUrl = CryptoImageUtil.getImageUrl(symbol, customUrl: iconUrl);

    return CircleAvatar(
      radius: 20.r,
      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) {
        // Fallback to text if image fails to load
      },
      child: imageUrl.contains('placeholder') || imageUrl.isEmpty
          ? Text(
              symbol.length > 3 ? symbol.substring(0, 3) : symbol,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                fontSize: 10.sp,
              ),
            )
          : null,
    );
  }

  // NEW: Recent Transactions Section
  Widget _buildRecentTransactions(BuildContext context, HomeState state) {
    final recentTransactions = state.recentTransactions.take(5).toList();

    if (recentTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: recentTransactions
              .map((transaction) => _buildTransactionItem(transaction))
              .toList(),
        ),
      ],
    );
  }

  // NEW: Build individual transaction item
  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final bool isReceive = (transaction['amount'] as num).toDouble() > 0;
    final double amount = (transaction['amount'] as num).toDouble();
    final String coin = transaction['coin']?.toString() ?? 'Unknown';
    final String date = transaction['date']?.toString() ?? '';
    final String hash = transaction['hash']?.toString() ?? '';

    final Color amountColor = isReceive
        ? AppColors.primaryColor
        : Colors.redAccent;
    final String amountPrefix = isReceive ? '+' : '-';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.muted.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Transaction type icon
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: isReceive
                  ? AppColors.primaryColor
                  : AppColors.muted.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isReceive
                    ? AppColors.primaryColor
                    : AppColors.muted.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              isReceive ? Icons.arrow_downward : Icons.arrow_upward,
              color: isReceive ? Colors.white : AppColors.secondaryText,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Transaction info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Coin avatar
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: AppColors.primaryColor,
                      child: Text(
                        coin.length > 4 ? coin.substring(0, 4) : coin,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _getShortHash(hash),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  _formatTransactionDate(date),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          // Amount column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix${amount.abs().toStringAsFixed(4)} $coin',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                isReceive ? 'Received' : 'Sent',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletInfo(HomeState state) {
    if (state.walletAddress.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Information',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 16.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Connected Wallet',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              Text(
                'TON Network',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () => _copyToClipboard(context, state.walletAddress),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.muted.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.walletAddress,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.secondaryText,
                        fontFamily: 'Monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.copy, size: 14.sp, color: AppColors.primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getShortWalletAddress(String address) {
    if (address.length <= 12) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 6)}';
  }

  String _getShortHash(String hash) {
    if (hash.length <= 12) return hash;
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 6)}';
  }

  String _formatTransactionDate(String date) {
    try {
      // Format: "25-11-03 11:54" to "Nov 03, 11:54"
      final parts = date.split(' ');
      if (parts.length == 2) {
        final datePart = parts[0];
        final timePart = parts[1];
        final dateParts = datePart.split('-');
        if (dateParts.length == 3) {
          final month = _getMonthName(int.parse(dateParts[1]));
          final day = dateParts[2];
          return '$month $day, $timePart';
        }
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard: ${_getShortWalletAddress(text)}',
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showWalletQrCode(BuildContext context, String walletAddress) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Wallet Address QR',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.muted.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.qr_code_2,
                size: 120.sp,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _getShortWalletAddress(walletAddress),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondaryText,
                fontFamily: 'Monospace',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _copyToClipboard(context, walletAddress);
              Navigator.of(context).pop();
            },
            child: const Text('Copy Address'),
          ),
        ],
      ),
    );
  }
}
