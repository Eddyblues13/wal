// lib/pages/home/dialog/send_crypto_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/home/bloc/home_bloc.dart';
import 'package:wal/pages/home/bloc/home_state.dart';

class SendCryptoPage extends StatelessWidget {
  const SendCryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final cryptoAssets = [
          {
            'symbol': 'USDT',
            'network': 'TRC20',
            'amount': '250.00',
            'value': '\$250.00',
            'balance': 250.0,
          },
          {
            'symbol': 'TAPCOIN',
            'network': 'BEP20',
            'amount': '1,200.00',
            'value': '\$60.00',
            'balance': 1200.0,
          },
          {
            'symbol': 'TON',
            'network': 'TON Network',
            'amount': '35.00',
            'value': '\$245.00',
            'balance': 35.0,
          },
        ];

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
                // Assets List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: cryptoAssets.length,
                    itemBuilder: (context, index) {
                      final asset = cryptoAssets[index];
                      return _buildAssetItem(context, asset);
                    },
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      asset['amount'],
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      asset['value'],
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

  void _showSendAmountPage(BuildContext context, Map<String, dynamic> asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SendAmountPage(asset: asset);
      },
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
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _amountController.text = '0';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _amountFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                  'Send ${widget.asset['symbol']}',
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
          // Network Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Text(
                  'COIN',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryText,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  widget.asset['network'],
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Balance
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance:',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  widget.asset['amount'],
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Amount Input Field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _amountController,
              focusNode: _amountFocusNode,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  color: AppColors.secondaryText.withOpacity(0.5),
                  fontSize: 32.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '≈ \$${(double.tryParse(_amountController.text.isNotEmpty ? _amountController.text : '0') ?? 0) * 45000}',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16.sp),
          ),
          SizedBox(height: 32.h),
          // Max Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  _amountController.text = widget.asset['balance'].toString();
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
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed:
                    _amountController.text.isEmpty ||
                        _amountController.text == '0' ||
                        double.tryParse(_amountController.text) == null
                    ? null
                    : () {
                        final amount = double.parse(_amountController.text);
                        if (amount > 0) {
                          Navigator.pop(context);
                          _showSendConfirmation(context, widget.asset, amount);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _amountController.text.isEmpty ||
                          _amountController.text == '0' ||
                          double.tryParse(_amountController.text) == null
                      ? AppColors.secondaryText.withOpacity(0.3)
                      : AppColors.primaryColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Text(
                  'Send',
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

  void _showSendConfirmation(
    BuildContext context,
    Map<String, dynamic> asset,
    double amount,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Confirm Send',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Send $amount ${asset['symbol']}?',
          style: TextStyle(color: AppColors.secondaryText, fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sent $amount ${asset['symbol']} successfully!',
                  ),
                  backgroundColor: AppColors.primaryColor,
                ),
              );
            },
            child: Text(
              'Confirm',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
