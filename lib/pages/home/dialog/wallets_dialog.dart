// lib/pages/home/dialog/wallets_dialog.dart
import 'package:flutter/material.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/home/dialog/notifications_page.dart';
import 'package:wal/pages/home/dialog/settings_page.dart';
import 'package:wal/pages/home/dialog/wallet_creation_page.dart';

/// Show a "Trust Wallet style" full-screen wallets modal.
/// Matches the screenshot: header (X, Wallets, bell/gear), two rounded wallet cards,
/// green backup links, and a full-width pill "Add wallet" button at the bottom.
Future<void> showWalletsDialog(BuildContext context) {
  final Color bg = const Color(0xFF151515); // modal background
  final Color pageBg = const Color(0xFF0F0F0F); // overall dark page background
  final Color cardColor = const Color(0xFF222425);
  final Color secondaryText = const Color(0xFF9A9A9A);
  final Color primaryColor = const Color(
    0xFF22C55E,
  ); // bright green for links/buttons

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.8), // Darker overlay
    isDismissible: false, // Prevent closing on tap outside
    enableDrag: false, // Prevent closing by dragging down
    builder: (sheetContext) {
      final height = MediaQuery.of(sheetContext).size.height;
      return PopScope(
        canPop: false, // Prevent closing with system back button
        child: Container(
          height: height * 0.95, // nearly full screen like screenshot
          margin: const EdgeInsets.only(top: 6), // slight gap from top
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            children: [
              // --- Header (X, Title, bell/settings) ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // close X inside faint rounded rectangle (like screenshot)
                    InkWell(
                      onTap: () => Navigator.of(sheetContext).pop(),
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ),

                    // Title centered visually
                    Expanded(
                      child: Center(
                        child: Text(
                          'Wallets',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Bell and Settings icons (same compact style)
                    Row(
                      children: [
                        // Notifications Icon
                        InkWell(
                          onTap: () {
                            // Open Notifications page without closing the dialog
                            Navigator.of(sheetContext).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationsPage(),
                              ),
                            );
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.notifications_none,
                                size: 20,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Settings Icon
                        InkWell(
                          onTap: () {
                            // Open Settings page without closing the dialog
                            Navigator.of(sheetContext).push(
                              MaterialPageRoute(
                                builder: (_) => const SettingsPage(),
                              ),
                            );
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.settings,
                                size: 20,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // small section label
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Text(
                  'Multi-coin wallets',
                  style: TextStyle(color: secondaryText, fontSize: 13),
                ),
              ),

              // --- Wallet list area (scrollable if needed) ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // First wallet card: "eddy blues" (with verified badge & one backup line)
                      _walletCard(
                        name: 'eddy blues',
                        subtitle: 'Multi-coin wallet',
                        showVerifiedBadge: true,
                        backupLines: ['Back up to iCloud'],
                        cardColor: cardColor,
                        secondaryText: secondaryText,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 12),

                      // Second wallet card: "Main Wallet 1" with two backup lines
                      _walletCard(
                        name: 'Main Wallet 1',
                        subtitle: 'Multi-coin wallet',
                        showVerifiedBadge: false,
                        backupLines: ['Back up manually', 'Back up to iCloud'],
                        cardColor: cardColor,
                        secondaryText: secondaryText,
                        primaryColor: primaryColor,
                      ),

                      // Add extra vertical padding to match screenshot spacing
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // --- Add wallet button (full width pill) ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to wallet creation page without closing the dialog
                      Navigator.of(sheetContext).push(
                        MaterialPageRoute(
                          builder: (context) => const WalletCreationPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: AppColors.primaryText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add wallet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Internal helper: builds wallet card matching screenshot styling.
Widget _walletCard({
  required String name,
  required String subtitle,
  required bool showVerifiedBadge,
  required List<String> backupLines,
  required Color cardColor,
  required Color secondaryText,
  required Color primaryColor,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // avatar with optional verified badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryText,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.shield_rounded,
                  color: Color(0xFF2B6BEF),
                  size: 22,
                ),
              ),
            ),
            if (showVerifiedBadge)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF0F0F0F),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 12),

        // name & subtitle & backups
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name + trailing menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert, color: Color(0xFFBFBFBF)),
                ],
              ),

              const SizedBox(height: 6),
              // subtitle
              Text(
                subtitle,
                style: TextStyle(color: secondaryText, fontSize: 13),
              ),

              const SizedBox(height: 12),

              // backup lines (each a green link like screenshot)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: backupLines
                    .map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            // implement backup action
                          },
                          child: Text(
                            line,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
