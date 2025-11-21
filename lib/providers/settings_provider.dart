import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/enums.dart';
import '../core/constants.dart';
import '../services/audio_service.dart';
import '../services/vibration_service.dart';

class SettingsProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.turkish;
  AppFont _font = AppFont.custom;
  bool _isMuted = false;
  bool _isVibrationEnabled = true;

  AppLanguage get language => _language;
  AppFont get font => _font;
  bool get isMuted => _isMuted;
  bool get isVibrationEnabled => _isVibrationEnabled;

  String getText(String key) {
    String langCode = _language == AppLanguage.turkish ? 'tr' : 'en';
    return AppTexts.translations[langCode]?[key] ?? key;
  }

  String? get fontFamily => _font == AppFont.custom ? 'Monogram' : null;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = AppLanguage.values[prefs.getInt('language') ?? 0];
    _font = AppFont.values[prefs.getInt('font') ?? 0];
    _isMuted = prefs.getBool('is_muted') ?? false;
    _isVibrationEnabled = prefs.getBool('is_vibration') ?? true;

    
    AudioService().isMuted = _isMuted;
    VibrationService().isEnabled = _isVibrationEnabled;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', lang.index);
    notifyListeners();
  }

  Future<void> setFont(AppFont font) async {
    _font = font;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('font', font.index);
    notifyListeners();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    AudioService().isMuted = _isMuted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_muted', _isMuted);
    notifyListeners();
  }

  Future<void> toggleVibration() async {
    _isVibrationEnabled = !_isVibrationEnabled;
    VibrationService().isEnabled = _isVibrationEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_vibration', _isVibrationEnabled);
    notifyListeners();
  }
}