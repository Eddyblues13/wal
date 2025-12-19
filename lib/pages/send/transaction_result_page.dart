// lib/pages/send/transaction_result_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';

class TransactionResultPage extends StatelessWidget {
  final bool isSuccess;
  final String message;
  final String? coinSymbol;
  final String? amount;
  final String? transactionHash;

  const TransactionResultPage({
    super.key,
    required this.isSuccess,
    required this.message,
    this.coinSymbol,
    this.amount,
    this.transactionHash,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60.h),
                    // Animated Icon Container
                    _buildIconContainer(),
                    SizedBox(height: 32.h),
                    // Title
                    _buildTitle(),
                    SizedBox(height: 16.h),
                    // Message
                    _buildMessage(),
                    SizedBox(height: 32.h),
                    // Transaction Details (if success)
                    if (isSuccess && coinSymbol != null && amount != null)
                      _buildTransactionDetails(),
                    SizedBox(height: 24.h),
                    // Transaction Hash (if available)
                    if (isSuccess && transactionHash != null)
                      _buildTransactionHash(transactionHash!),
                  ],
                ),
              ),
            ),
            // OK Button
            _buildOkButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSuccess
              ? [
                  Colors.green.withOpacity(0.2),
                  Colors.green.withOpacity(0.1),
                ]
              : [
                  Colors.red.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: (isSuccess ? Colors.green : Colors.red).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isSuccess ? Icons.check_circle : Icons.error_outline,
          size: 64.sp,
          color: isSuccess ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      isSuccess ? 'Transaction Successful!' : 'Transaction Failed',
      style: TextStyle(
        color: AppColors.primaryText,
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: AppColors.secondaryText,
          fontSize: 16.sp,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow('Coin', coinSymbol ?? ''),
          SizedBox(height: 12.h),
          _buildDetailRow('Amount', amount ?? ''),
          SizedBox(height: 12.h),
          _buildDetailRow('Network', 'TON'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHash(String hash) {
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
            'Transaction Hash',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          SelectableText(
            hash,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12.sp,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOkButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

