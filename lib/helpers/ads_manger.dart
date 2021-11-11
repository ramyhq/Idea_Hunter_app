

import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  bool _testMode = false;
  Future<InitializationStatus> initialization;

  AdsManager({required this.initialization});


   String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4*********0~1*********478";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get bannerAdUnitId {
    if (_testMode == true) {
      return "ca-app-pub-3940256099942544/6300978111"; //test bannerAdUnitId
    } else if (Platform.isAndroid) {
      return "ca-app-pub-****76*********0/7*********9";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  BannerAdListener get adListener => _adListener;

   final BannerAdListener _adListener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );








}