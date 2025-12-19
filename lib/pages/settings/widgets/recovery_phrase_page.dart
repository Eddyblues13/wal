// lib/pages/settings/widgets/recovery_phrase_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/global.dart';
import 'package:wal/common/widgets/flutter_toast.dart';

class RecoveryPhrasePage extends StatefulWidget {
  const RecoveryPhrasePage({super.key});

  @override
  State<RecoveryPhrasePage> createState() => _RecoveryPhrasePageState();
}

class _RecoveryPhrasePageState extends State<RecoveryPhrasePage> {
  String? _mnemonic;
  bool _isRevealed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMnemonic();
  }

  Future<void> _loadMnemonic() async {
    try {
      final mnemonic = Global.storageService.getUserMnemonic();
      setState(() {
        _mnemonic = mnemonic;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        toastInfo(msg: "Failed to load recovery phrase");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    )
                  : _mnemonic == null || _mnemonic!.isEmpty
                      ? _buildEmptyState()
                      : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18.sp,
                color: AppColors.primaryText,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Recovery Phrase',
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64.sp,
              color: AppColors.muted,
            ),
            SizedBox(height: 24.h),
            Text(
              'No Recovery Phrase Found',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Your recovery phrase is not available. Please contact support if you need to recover your wallet.',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Warning
          _buildSecurityWarning(),

          SizedBox(height: 32.h),

          // Reveal Button
          if (!_isRevealed) _buildRevealButton(),

          // Recovery Phrase Display
          if (_isRevealed) ...[
            _buildRecoveryPhraseGrid(),
            
            SizedBox(height: 24.h),
            
            // Copy Button
            _buildCopyButton(),
            
            SizedBox(height: 32.h),
            
            // Backup Instructions
            _buildBackupInstructions(),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityWarning() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange.shade700,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Security Warning',
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Never share your recovery phrase with anyone. Anyone with these words can access your wallet and funds.',
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '• Store it offline in a secure location\n• Never take screenshots\n• Never enter it on suspicious websites',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showConfirmDialog();
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: Colors.white,
                  size: 22.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Reveal Recovery Phrase',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Make sure no one is watching your screen. Never share your recovery phrase with anyone.',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isRevealed = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'I Understand',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryPhraseGrid() {
    final words = _mnemonic!.trim().split(' ').where((w) => w.isNotEmpty).toList();
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Your Recovery Phrase',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: words.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          words[index],
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCopyButton() {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _copyToClipboard,
          borderRadius: BorderRadius.circular(16.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.copy_rounded,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Copy to Clipboard',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackupInstructions() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primaryColor,
                size: 22.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'How to Backup',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInstructionItem(
            icon: Icons.edit_note_rounded,
            text: 'Write it down on paper and store it in a safe place',
          ),
          SizedBox(height: 12.h),
          _buildInstructionItem(
            icon: Icons.lock_outline_rounded,
            text: 'Store multiple copies in different secure locations',
          ),
          SizedBox(height: 12.h),
          _buildInstructionItem(
            icon: Icons.block_rounded,
            text: 'Never store it digitally or take screenshots',
          ),
          SizedBox(height: 12.h),
          _buildInstructionItem(
            icon: Icons.shield_outlined,
            text: 'Keep it private - never share with anyone',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 18.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard() {
    if (_mnemonic == null || _mnemonic!.isEmpty) return;

    Clipboard.setData(ClipboardData(text: _mnemonic!));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Recovery phrase copied to clipboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(16.w),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

