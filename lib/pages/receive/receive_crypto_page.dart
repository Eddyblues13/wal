// lib/pages/receive/receive_crypto_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/common/utils/crypto_image_util.dart';
import 'package:wal/common/widgets/flutter_toast.dart';
import 'package:wal/pages/receive/bloc/receive_bloc.dart';
import 'package:wal/pages/receive/bloc/receive_event.dart';
import 'package:wal/pages/receive/bloc/receive_state.dart';
import 'package:wal/pages/receive/receive_controller.dart';

class ReceiveCryptoPage extends StatefulWidget {
  const ReceiveCryptoPage({super.key});

  @override
  State<ReceiveCryptoPage> createState() => _ReceiveCryptoPageState();
}

class _ReceiveCryptoPageState extends State<ReceiveCryptoPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasInitialized = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceiveBloc(),
      child: Builder(
        builder: (blocContext) {
          // Load addresses once when bloc is available
          if (!_hasInitialized) {
            _hasInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                ReceiveController(context: blocContext).loadReceiveAddresses();
              }
            });
          }

          return BlocBuilder<ReceiveBloc, ReceiveState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppColors.background,
                body: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(context),

                      // Search Bar
                      _buildSearchBar(context, state),

                      // All Crypto Label
                      _buildAllCryptoLabel(),

                      // Main Content
                      Expanded(
                        child: state.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColor,
                                  ),
                                ),
                              )
                            : state.error.isNotEmpty && state.assets.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 64.sp,
                                          color: AppColors.secondaryText,
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          state.error,
                                          style: TextStyle(
                                            color: AppColors.secondaryText,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        ElevatedButton(
                                          onPressed: () {
                                            ReceiveController(context: context)
                                                .refreshReceiveAddresses();
                                          },
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  )
                                : _buildContent(context, state),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildSearchBar(BuildContext context, ReceiveState state) {
    return Padding(
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
          controller: _searchController,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.secondaryText,
            ),
            hintText: 'Search crypto',
            hintStyle: TextStyle(color: AppColors.secondaryText),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          ),
          onChanged: (value) {
            context.read<ReceiveBloc>().add(SearchAssetsEvent(value));
          },
        ),
      ),
    );
  }

  Widget _buildAllCryptoLabel() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'All Crypto',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReceiveState state) {
    // Filter only TON network coins and limit to 3
    final tonCoins = state.assets
        .where((asset) =>
            (asset['network'] as String? ?? '').toUpperCase() == 'TON')
        .take(3)
        .toList();

    // Apply search filter
    final displayAssets = state.searchQuery.isNotEmpty
        ? tonCoins.where((asset) {
            final query = state.searchQuery.toLowerCase();
            final symbol = (asset['symbol'] ?? '').toString().toLowerCase();
            final name = (asset['name'] ?? '').toString().toLowerCase();
            return symbol.contains(query) || name.contains(query);
          }).toList()
        : tonCoins;

    if (displayAssets.isEmpty) {
      return Center(
        child: Text(
          'No crypto found',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: displayAssets.length,
      itemBuilder: (context, index) {
        final asset = displayAssets[index];
        return _buildAssetItem(context, asset);
      },
    );
  }

  Widget _buildAssetItem(BuildContext context, Map<String, dynamic> asset) {
    final logoPath = asset['logo'] as String?;
    final symbol = asset['symbol'] as String? ?? '';
    final address = asset['address'] ?? '';
    final imageUrl = CryptoImageUtil.getImageUrl(symbol, customUrl: logoPath);
    final shortenedAddress = address.length > 18
        ? '${address.substring(0, 10)}...${address.substring(address.length - 8)}'
        : address;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showReceiveAddressPage(context, asset, address);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Coin Logo - Fetch from online
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Image.network(
                    imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultLogo(symbol);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildDefaultLogo(symbol);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'TON',
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

  Widget _buildDefaultLogo(String symbol) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
      child: Text(
        symbol.isNotEmpty ? symbol[0] : '?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
          fontSize: 16.sp,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Header with TON Network indicator
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Receive ${asset['symbol'] ?? ''}',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.secondaryText,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // TON Network Badge
                Container(
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
                        Icons.network_check,
                        size: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'TON Network',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Warning
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 20.sp,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Only send ${asset['symbol'] ?? ''} (${asset['name'] ?? ''}) on send to TON network. Other assets will be lost forever.',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 13.sp,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // QR Code Placeholder
                  Container(
                    width: 240.w,
                    height: 240.w,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.qr_code_2,
                        size: 200.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Address Card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet Address',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SelectableText(
                          address,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context,
                          icon: Icons.copy,
                          label: 'Copy',
                          onTap: () => _copyAddress(context, address),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildActionButton(
                          context,
                          icon: Icons.share,
                          label: 'Share',
                          onTap: () => _shareAddress(context, address, asset),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyAddress(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address));
    toastInfo(msg: "Address copied to clipboard");
    Navigator.pop(context);
  }

  Future<void> _shareAddress(
    BuildContext context,
    String address,
    Map<String, dynamic> asset,
  ) async {
    final shareText =
        'My ${asset['symbol'] ?? ''} (${asset['name'] ?? ''}) address on TON Network:\n$address';
    
    try {
      await Share.share(
        shareText,
        subject: '${asset['symbol'] ?? ''} Receive Address',
      );
    } catch (e) {
      // Fallback to clipboard if share fails
      Clipboard.setData(ClipboardData(text: shareText));
      toastInfo(msg: "Address copied to clipboard");
    }
    // Don't close modal on share - let user close it manually
  }
}
