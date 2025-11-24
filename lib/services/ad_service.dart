import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  
  
  
  static const bool _adsEnabled = false; 

  InterstitialAd? _interstitialAd;
  int _gameOverCounter = 0;
  final int _adFrequency = 3;

  
  bool get areAdsEnabled => _adsEnabled;

  Future<void> init() async {
    
    if (!_adsEnabled) return;

    await MobileAds.instance.initialize();
    _loadInterstitial();
  }

  void _loadInterstitial() {
    if (!_adsEnabled) return; 

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _loadInterstitial();
            }
          );
        },
        onAdFailedToLoad: (err) {
          print('Interstitial failed: $err');
          _interstitialAd = null;
        }
      )
    );
  }

  void showInterstitialIfReady() {
    if (!_adsEnabled) return; 

    _gameOverCounter++;
    if (_gameOverCounter >= _adFrequency) {
      if (_interstitialAd != null) {
        _interstitialAd!.show();
        _gameOverCounter = 0;
      }
    }
  }
}