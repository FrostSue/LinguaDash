import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_helper.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // --- REKLAM KONTROL ANAHTARI ---
  static const bool _adsEnabled = true;
  bool get areAdsEnabled => _adsEnabled;

  // --- DEĞİŞKENLER ---
  InterstitialAd? _interstitialAd;
  
  // Sayaç: Kaç oyun bitti?
  int _gameOverCounter = 0;
  
  // Frekans: Kaç oyunda bir reklam çıksın? (Test için 1 yapabilirsin, normalde 3)
  final int _adFrequency = 3; 
  
  // Yükleme Denemesi
  int _numInterstitialLoadAttempts = 0;
  final int _maxFailedLoadAttempts = 3;

  // --- BAŞLATMA ---
  Future<void> init() async {
    if (!_adsEnabled) return;

    await MobileAds.instance.initialize();
    _createInterstitialAd();
  }

  // --- REKLAMI YÜKLEME ---
  void _createInterstitialAd() {
    if (!_adsEnabled) return;

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('✅ INTERSTITIAL: Hazır');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('ℹ️ INTERSTITIAL: Kapatıldı');
              ad.dispose();
              _createInterstitialAd(); // Yenisini yükle
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('❌ INTERSTITIAL: Gösterim Hatası: $error');
              ad.dispose();
              _createInterstitialAd(); // Yenisini yükle
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ INTERSTITIAL: Yükleme Hatası: $error');
          _interstitialAd = null;
          _numInterstitialLoadAttempts += 1;
          
          if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
            Timer(const Duration(seconds: 5), () {
              _createInterstitialAd();
            });
          }
        },
      ),
    );
  }

  // --- GÖSTERME MANTIĞI ---
  void showInterstitialIfReady() {
    if (!_adsEnabled) return;

    _gameOverCounter++;
    print("🎲 OYUN SAYACI: $_gameOverCounter / $_adFrequency");

    // Sayaç doldu mu?
    if (_gameOverCounter >= _adFrequency) {
      
      // Reklam hazır mı?
      if (_interstitialAd != null) {
        print("🚀 REKLAM GÖSTERİLİYOR...");
        _interstitialAd!.show();
        _gameOverCounter = 0; // Sayacı sıfırla
      } else {
        print("⚠️ REKLAM HAZIR DEĞİL, TEKRAR YÜKLENİYOR...");
        // Eğer reklam hazır değilse sayacı sıfırlamıyoruz,
        // bir sonraki oyunda tekrar şansını denesin diye.
        _createInterstitialAd();
      }
    }
  }
}