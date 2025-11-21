import 'package:flutter/services.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal();

  bool isEnabled = true;

  Future<void> vibrateError() async {
    if (!isEnabled) return;
    await HapticFeedback.heavyImpact();
  }

  Future<void> vibrateClick() async {
    if (!isEnabled) return;
    await HapticFeedback.lightImpact();
  }
}