import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../providers/settings_provider.dart';

class LegalDialog extends StatelessWidget {
  final String title;
  final String content;
  final SettingsProvider settings;

  const LegalDialog({
    super.key,
    required this.title,
    required this.content,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: settings.fontFamily,
          color: AppColors.primaryPurple,
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            settings.getText('ok'),
            style: const TextStyle(color: AppColors.secondaryTeal, fontWeight: FontWeight.bold)
          ),
        )
      ],
    );
  }
}