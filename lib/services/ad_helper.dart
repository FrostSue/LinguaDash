import 'dart:io';
import 'package:flutter/foundation.dart';
import 'ad_secrets.dart';

class AdHelper {
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  
  static const String _testBannerIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialIOS = 'ca-app-pub-3940256099942544/4411468910';


  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode ? AdSecrets.androidBanner : _testBannerAndroid;
    } else if (Platform.isIOS) {
      return kReleaseMode ? AdSecrets.iosBanner : _testBannerIOS;
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode ? AdSecrets.androidInterstitial : _testInterstitialAndroid;
    } else if (Platform.isIOS) {
      return kReleaseMode ? AdSecrets.iosInterstitial : _testInterstitialIOS;
    }
    throw UnsupportedError("Unsupported platform");
  }

}