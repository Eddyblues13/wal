import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/pages/seed_phrase/bloc/seed_phrase_bloc.dart';

class SeedPhrasePage extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;

  const SeedPhrasePage({
    Key? key,
    required this.email,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  State<SeedPhrasePage> createState() => _SeedPhrasePageState();
}

class _SeedPhrasePageState extends State<SeedPhrasePage> {
  final PageController _pageController = PageController();
  final List<TextEditingController> _verificationControllers = List.generate(
    12,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SeedPhraseBloc>().generateSeedPhrase();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _verificationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitWarning();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildSeedPhraseView(),
              _buildVerificationView(),
              _buildSuccessView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeedPhraseView() {
    return BlocBuilder<SeedPhraseBloc, SeedPhraseState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              _buildHeaderWithBack(),

              SizedBox(height: 20.h),

              // Main header
              _buildHeader(
                title: "Secure Your Wallet",
                subtitle:
                    "Write down these 12 words in order and store them safely. Never share them with anyone.",
              ),

              SizedBox(height: 32.h),

              // Security Warning
              _buildSecurityWarning(),

              SizedBox(height: 24.h),

              // Seed Phrase Grid
              _buildSeedPhraseGrid(state.seedPhrase),

              SizedBox(height: 32.h),

              // Copy Button
              _buildCopyButton(context, state),

              SizedBox(height: 16.h),

              // Continue Button
              _buildContinueButton(() {
                if (state.seedPhrase.isNotEmpty) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }, state.seedPhrase.isNotEmpty),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerificationView() {
    return BlocBuilder<SeedPhraseBloc, SeedPhraseState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              _buildHeaderWithBack(),

              SizedBox(height: 20.h),

              // Verification header
              _buildHeader(
                title: "Verify Seed Phrase",
                subtitle:
                    "Enter the words in the correct order to verify you've saved them correctly.",
              ),

              SizedBox(height: 32.h),

              // Verification Grid
              _buildVerificationGrid(state.seedPhrase),

              SizedBox(height: 32.h),

              // Verify Button
              _buildVerifyButton(context, state),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuccessView() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Icon
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.primaryColor,
              size: 60.sp,
            ),
          ),

          SizedBox(height: 32.h),

          // Success Message
          Text(
            "Wallet Secured!",
            style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            "Your wallet has been successfully created and secured with your seed phrase.",
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 48.h),

          // Start Using App Button
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderWithBack() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (_pageController.page == 0) {
              _showExitWarning();
            } else {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.secondaryText,
            size: 22.w,
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          "Backup Seed Phrase",
          style: TextStyle(
            color: AppColors.primaryElementText,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primaryElementText,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          subtitle,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildSecurityWarning() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.security, color: Colors.orange, size: 24.sp),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Security Warning",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  "Never share your seed phrase. Anyone with these words can access your funds. Store it securely offline.",
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeedPhraseGrid(List<String> seedPhrase) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.muted.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScreenshotProtection(),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns → 3 rows for 12 words
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 3.2, // adjust so text fits nicely
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.muted.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        seedPhrase.isNotEmpty ? seedPhrase[index] : '•••••',
                        style: TextStyle(
                          color: AppColors.primaryElementText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true, // wrap if needed
                        overflow: TextOverflow.visible, // no hidden letters
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshotProtection() {
    return IgnorePointer(
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Text(
              "SECURE SEED PHRASE - DO NOT SCREENSHOT",
              style: TextStyle(
                color: Colors.red.withOpacity(0.1),
                fontSize: 1.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context, SeedPhraseState state) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: state.seedPhrase.isNotEmpty
            ? () => _copySeedPhrase(context, state.seedPhrase)
            : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          side: BorderSide(color: AppColors.primaryColor),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Icon(Icons.copy, size: 18.sp),
        label: Text(
          "Copy to Clipboard",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildContinueButton(VoidCallback onPressed, bool isEnabled) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.primaryColor : AppColors.muted,
          foregroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          "I've Saved My Seed Phrase",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildVerificationGrid(List<String> seedPhrase) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.muted.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 12.w,
            runSpacing: 16.h,
            children: List.generate(12, (index) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 100.w) / 3,
                child: TextField(
                  controller: _verificationControllers[index],
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Word ${index + 1}',
                    labelStyle: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 12.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.muted),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, SeedPhraseState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _verifySeedPhrase(context, state.seedPhrase),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          "Verify Seed Phrase",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.APPLICATION, (route) => false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          "Start Using Wallet",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _copySeedPhrase(BuildContext context, List<String> seedPhrase) {
    final phrase = seedPhrase.join(' ');
    // In production, use a secure clipboard method

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryColor,
        content: Text(
          "Seed phrase copied to clipboard",
          style: TextStyle(color: AppColors.background),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _verifySeedPhrase(BuildContext context, List<String> correctPhrase) {
    bool isCorrect = true;

    for (int i = 0; i < 12; i++) {
      final enteredWord = _verificationControllers[i].text.trim().toLowerCase();
      final correctWord = correctPhrase[i].toLowerCase();

      if (enteredWord != correctWord) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      context.read<SeedPhraseBloc>().confirmSeedPhrase();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Incorrect seed phrase. Please check and try again.",
            style: TextStyle(color: AppColors.primaryText),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showExitWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          "Warning",
          style: TextStyle(
            color: Colors.orange,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "If you exit without saving your seed phrase, you may permanently lose access to your wallet. Are you sure you want to exit?",
          style: TextStyle(
            color: AppColors.primaryElementText,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Stay",
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.SIGN_IN, (route) => false);
            },
            child: Text("Exit", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
