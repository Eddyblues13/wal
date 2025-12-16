import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/home/bloc/history_bloc.dart';
import 'package:wal/pages/home/bloc/history_event.dart';
import 'package:wal/pages/home/bloc/history_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc()..add(const HistoryLoadData()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 12.h),
                _buildTopBar(context),
                SizedBox(height: 12.h),
                Expanded(child: _buildHistoryContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        return Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18.sp,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Center(
                child: Text(
                  'History',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
            // Network selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Text(
                    state.selectedNetwork,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18.sp,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryContent() {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoadingState();
        }

        if (state.error.isNotEmpty) {
          return _buildErrorState(context, state.error);
        }

        if (state.transactions.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildTransactionList(context, state);
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: CircularProgressIndicator(
              strokeWidth: 3.w,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading transactions...',
            style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.sp, color: AppColors.muted),
          SizedBox(height: 16.h),
          Text(
            'Failed to load history',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              error.length > 100 ? '${error.substring(0, 100)}...' : error,
              style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<HistoryBloc>().add(const HistoryRefreshData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Try Again',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 48.sp, color: AppColors.muted),
          SizedBox(height: 16.h),
          Text(
            'No Transactions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your transaction history will appear here',
            style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<HistoryBloc>().add(const HistoryRefreshData());
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
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, HistoryState state) {
    // Group transactions by date
    final Map<String, List<Map<String, dynamic>>> groupedTransactions = {};

    for (final transaction in state.transactions) {
      final date =
          transaction['date']?.toString().split(' ').first ?? 'Unknown Date';
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    // Convert to list of sections
    final sections = groupedTransactions.entries.map((entry) {
      return _TxnSection(
        dateLabel: _formatDate(entry.key),
        items: entry.value.map((txn) => _convertApiTransaction(txn)).toList(),
      );
    }).toList();

    // Sort sections by date (newest first)
    sections.sort((a, b) => b.dateLabel.compareTo(a.dateLabel));

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HistoryBloc>().add(const HistoryRefreshData());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 32.h, top: 6.h),
        itemCount: sections.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, sIndex) {
          final section = sections[sIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
                child: Text(
                  section.dateLabel,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Column(
                children: section.items
                    .map((txn) => _buildTxnTile(context, txn))
                    .toList(growable: false),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTxnTile(BuildContext context, _TxnItem txn) {
    final bool isReceive = txn.amount > 0;
    final Color amountColor = isReceive
        ? AppColors.primaryColor
        : Colors.redAccent;
    final String amountPrefix = isReceive ? '+' : '-';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Transaction type icon
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              isReceive ? Icons.arrow_downward : Icons.arrow_upward,
              color: isReceive
                  ? AppColors.primaryColor
                  : AppColors.secondaryText,
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
                      backgroundColor: AppColors.primaryColor.withOpacity(0.12),
                      child: Text(
                        txn.coin.length > 4
                            ? txn.coin.substring(0, 4)
                            : txn.coin,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        txn.shortAddress,
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
                GestureDetector(
                  onTap: () => _openExplorer(context, txn.explorerUrl),
                  child: Text(
                    'View on Explorer',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
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
                '$amountPrefix${txn.amount.abs().toStringAsFixed(4)} ${txn.coin}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                txn.dateTime,
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

  void _openExplorer(BuildContext context, String explorerUrl) {
    if (explorerUrl.isNotEmpty) {
      // In a real app, you would use url_launcher package
      // For now, show a dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Open Explorer', style: TextStyle(fontSize: 16.sp)),
          content: Text(
            'Would open: $explorerUrl',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add url_launcher implementation here
                // Example: launchUrl(Uri.parse(explorerUrl));
              },
              child: const Text('Open'),
            ),
          ],
        ),
      );
    }
  }

  String _formatDate(String date) {
    try {
      // Convert from "25-11-03" to "Nov 03 2025"
      final parts = date.split('-');
      if (parts.length == 3) {
        final year = '20${parts[0]}'; // Convert 25 to 2025
        final month = _getMonthName(int.parse(parts[1]));
        final day = parts[2];
        return '$month $day $year';
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

  _TxnItem _convertApiTransaction(Map<String, dynamic> apiTransaction) {
    final date = apiTransaction['date']?.toString() ?? '';
    final coin = apiTransaction['coin']?.toString() ?? 'Unknown';
    final amount = (apiTransaction['amount'] as num?)?.toDouble() ?? 0.0;
    final hash = apiTransaction['hash']?.toString() ?? '';
    final explorer = apiTransaction['explorer']?.toString() ?? '';

    // Extract time from date string (format: "25-11-03 11:54")
    final time = date.contains(' ') ? date.split(' ').last : '';

    return _TxnItem(
      type: amount >= 0 ? TxnType.receive : TxnType.send,
      coin: coin,
      shortAddress: _getShortHash(hash),
      amount: amount,
      dateTime: time,
      explorerUrl: explorer,
    );
  }

  String _getShortHash(String hash) {
    if (hash.length <= 12) return hash;
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 6)}';
  }
}

// Local models
enum TxnType { send, receive }

class _TxnItem {
  final TxnType type;
  final String coin;
  final String shortAddress;
  final double amount;
  final String dateTime;
  final String explorerUrl;

  _TxnItem({
    required this.type,
    required this.coin,
    required this.shortAddress,
    required this.amount,
    required this.dateTime,
    required this.explorerUrl,
  });
}

class _TxnSection {
  final String dateLabel;
  final List<_TxnItem> items;

  _TxnSection({required this.dateLabel, required this.items});
}
