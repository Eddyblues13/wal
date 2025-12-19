// lib/pages/send/send_crypto_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/common/utils/crypto_image_util.dart';
import 'package:wal/pages/send/bloc/send_bloc.dart';
import 'package:wal/pages/send/bloc/send_state.dart';
import 'package:wal/pages/send/send_controller.dart';
import 'package:wal/pages/send/transaction_result_page.dart';

class SendCryptoPage extends StatefulWidget {
  const SendCryptoPage({super.key});

  @override
  State<SendCryptoPage> createState() => _SendCryptoPageState();
}

class _SendCryptoPageState extends State<SendCryptoPage> {
  bool _hasInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendBloc(),
      child: Builder(
        builder: (blocContext) {
          // Load assets once when bloc is available
          if (!_hasInitialized) {
            _hasInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                SendController(context: blocContext).loadSendAssets();
              }
            });
          }

          return BlocListener<SendBloc, SendState>(
            listener: (context, state) {
              // Handle send transaction success/error
              if (state.sendSuccess && state.sendMessage.isNotEmpty) {
                // Navigate to success page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionResultPage(
                      isSuccess: true,
                      message: state.sendMessage,
                      coinSymbol: state.sendCoinSymbol,
                      amount: state.sendAmount,
                      transactionHash: state.transactionHash,
                    ),
                  ),
                );
                context.read<SendBloc>().resetSendTransaction();
              } else if (state.sendError.isNotEmpty && !state.isSending) {
                // Navigate to error page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionResultPage(
                      isSuccess: false,
                      message: state.sendError,
                      coinSymbol: state.sendCoinSymbol,
                      amount: state.sendAmount,
                    ),
                  ),
                );
                context.read<SendBloc>().resetSendTransaction();
              }
            },
            child: BlocBuilder<SendBloc, SendState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: AppColors.background,
                  body: SafeArea(
                    child: Column(
                      children: [
                        // Header
                        _buildHeader(context),

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
                                              SendController(context: context)
                                                  .refreshSendAssets();
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
            ),
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
                'Send',
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

  Widget _buildContent(BuildContext context, SendState state) {
    // Filter only TON network coins
    final tonCoins = state.assets
        .where((asset) =>
            (asset['network'] as String? ?? '').toUpperCase() == 'TON')
        .take(3)
        .toList();

    if (tonCoins.isEmpty) {
      return Center(
        child: Text(
          'No TON network coins available',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14.sp,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: tonCoins.length,
      itemBuilder: (context, index) {
        final asset = tonCoins[index];
        return _buildAssetItem(context, asset);
      },
    );
  }

  Widget _buildAssetItem(BuildContext context, Map<String, dynamic> asset) {
    final logoPath = asset['logo'] as String?;
    final symbol = asset['symbol'] as String? ?? '';
    final imageUrl = CryptoImageUtil.getImageUrl(symbol, customUrl: logoPath);

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
            _showSendAmountPage(context, asset);
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      asset['amount'] ?? '0.00',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      asset['value'] ?? '\$0.00',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
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

  void _showSendAmountPage(BuildContext context, Map<String, dynamic> asset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendAmountPage(asset: asset),
      ),
    );
  }
}

class SendAmountPage extends StatefulWidget {
  final Map<String, dynamic> asset;

  const SendAmountPage({super.key, required this.asset});

  @override
  State<SendAmountPage> createState() => _SendAmountPageState();
}

class _SendAmountPageState extends State<SendAmountPage> {
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _receiverFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '0';
  }

  @override
  void dispose() {
    _receiverController.dispose();
    _amountController.dispose();
    _receiverFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  double get _balance {
    final balance = widget.asset['balance'];
    if (balance is double) return balance;
    if (balance is int) return balance.toDouble();
    if (balance is String) {
      return double.tryParse(balance) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendBloc(),
      child: Builder(
        builder: (blocContext) {
          if (!_hasInitialized) {
            _hasInitialized = true;
            // Load assets if needed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && blocContext.mounted) {
                SendController(context: blocContext).loadSendAssets();
              }
            });
          }

          return BlocListener<SendBloc, SendState>(
            listener: (context, state) {
              // Handle send transaction success/error from SendAmountPage
              if (state.sendSuccess && state.sendMessage.isNotEmpty) {
                // Navigate to success page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionResultPage(
                      isSuccess: true,
                      message: state.sendMessage,
                      coinSymbol: state.sendCoinSymbol,
                      amount: state.sendAmount,
                      transactionHash: state.transactionHash,
                    ),
                  ),
                );
                context.read<SendBloc>().resetSendTransaction();
              } else if (state.sendError.isNotEmpty && !state.isSending) {
                // Navigate to error page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionResultPage(
                      isSuccess: false,
                      message: state.sendError,
                      coinSymbol: state.sendCoinSymbol,
                      amount: state.sendAmount,
                    ),
                  ),
                );
                context.read<SendBloc>().resetSendTransaction();
              }
            },
            child: BlocBuilder<SendBloc, SendState>(
              builder: (context, state) {
                return Scaffold(
                backgroundColor: AppColors.background,
                body: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(context),

                      // Content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(24.w),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Coin Info
                                _buildCoinInfo(),

                                SizedBox(height: 32.h),

                                // Receiver Address Field
                                _buildReceiverField(),

                                SizedBox(height: 24.h),

                                // Amount Field
                                _buildAmountField(state),

                                SizedBox(height: 32.h),

                                // Send Button
                                _buildSendButton(context, blocContext, state),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
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
                'Send ${widget.asset['symbol'] ?? ''}',
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

  Widget _buildCoinInfo() {
    final logoPath = widget.asset['logo'] as String?;
    final symbol = widget.asset['symbol'] as String? ?? '';
    final imageUrl = CryptoImageUtil.getImageUrl(symbol, customUrl: logoPath);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    symbol.isNotEmpty ? symbol[0] : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 20.sp,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    symbol.isNotEmpty ? symbol[0] : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 20.sp,
                    ),
                  ),
                );
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
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'TON Network',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Balance:',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${_balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiverField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receiver Wallet Address',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _receiverController,
          focusNode: _receiverFocusNode,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: 'Paste receiver wallet address',
            hintStyle: TextStyle(
              color: AppColors.secondaryText.withOpacity(0.5),
            ),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter receiver wallet address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAmountField(SendState state) {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final exceedsBalance = amount > _balance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Amount',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                _amountController.text = _balance.toStringAsFixed(2);
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'MAX',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _amountController,
          focusNode: _amountFocusNode,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(
              color: AppColors.secondaryText.withOpacity(0.5),
              fontSize: 24.sp,
            ),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            errorText: exceedsBalance
                ? 'Amount exceeds balance'
                : null,
          ),
          onChanged: (value) {
            setState(() {});
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            if (amount > _balance) {
              return 'Amount cannot exceed balance';
            }
            return null;
          },
        ),
        if (exceedsBalance)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'Amount cannot be greater than balance (${_balance.toStringAsFixed(2)})',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSendButton(
    BuildContext context,
    BuildContext blocContext,
    SendState state,
  ) {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final isValid = amount > 0 &&
        amount <= _balance &&
        _receiverController.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: (state.isSending || !isValid)
            ? null
            : () => _handleSend(context, blocContext),
        style: ElevatedButton.styleFrom(
          backgroundColor: (state.isSending || !isValid)
              ? AppColors.secondaryText.withOpacity(0.3)
              : AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: state.isSending
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryText,
                  ),
                ),
              )
            : Text(
                'Send',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _handleSend(BuildContext context, BuildContext blocContext) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || amount > _balance) {
      return;
    }

    final controller = SendController(context: blocContext);
    await controller.sendTransaction(
      _receiverController.text.trim(),
      widget.asset['symbol'] ?? '',
      amount.toStringAsFixed(2),
      'TON', // Always TON network
    );
  }
}
