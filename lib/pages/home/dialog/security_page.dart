import 'package:flutter/material.dart';
import 'package:wal/common/values/colors.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  // Back button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ),

                  // Title centered visually
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Security',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Placeholder for symmetry
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 6),

                  // Recovery Phrase
                  _SecurityTile(
                    icon: Icons.security,
                    label: 'Recovery Phrase',
                    description: 'Back up your wallet',
                    onTap: () => _showRecoveryPhraseDialog(context),
                  ),
                  _dividerLine(),

                  // Change PIN
                  _SecurityTile(
                    icon: Icons.pin,
                    label: 'Change PIN',
                    description: 'Update your security PIN',
                    onTap: () => _showChangePINDialog(context),
                  ),
                  _dividerLine(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _dividerLine() {
    return Container(
      height: 1,
      color: AppColors.divider,
      margin: const EdgeInsets.only(left: 16, right: 16),
    );
  }

  static void _showRecoveryPhraseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Recovery Phrase',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Text(
          'Make sure no one is watching your screen. Never share your recovery phrase with anyone.',
          style: TextStyle(color: AppColors.secondaryText),
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
              // Navigate to recovery phrase reveal
            },
            child: Text(
              'Continue',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  static void _showChangePINDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Change PIN',
          style: TextStyle(color: AppColors.primaryText),
        ),
        content: Text(
          'You will be prompted to enter your current PIN before setting a new one.',
          style: TextStyle(color: AppColors.secondaryText),
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
              // Navigate to PIN change flow
            },
            child: Text(
              'Continue',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  static void _showPrivateKeysWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Warning', style: TextStyle(color: Colors.orange)),
        content: Text(
          'Private keys give full access to your funds. Never share them with anyone. Make sure no one is watching your screen.',
          style: TextStyle(color: AppColors.secondaryText),
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
              // Navigate to private keys reveal
            },
            child: Text(
              'I Understand',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool hasSwitch;
  final bool isSwitched;
  final VoidCallback onTap;

  const _SecurityTile({
    required this.icon,
    required this.label,
    required this.description,
    this.hasSwitch = false,
    this.isSwitched = false,
    required this.onTap,
  });

  @override
  State<_SecurityTile> createState() => _SecurityTileState();
}

class _SecurityTileState extends State<_SecurityTile> {
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    _isSwitched = widget.isSwitched;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(widget.icon, color: AppColors.primaryText, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.hasSwitch)
                Switch(
                  value: _isSwitched,
                  onChanged: (value) {
                    setState(() {
                      _isSwitched = value;
                    });
                  },
                  activeColor: AppColors.primaryColor,
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.primaryText),
            ],
          ),
        ),
      ),
    );
  }
}
