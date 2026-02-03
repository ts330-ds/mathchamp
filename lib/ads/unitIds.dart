import 'dart:io';

abstract class UnitIds {
  // Test Ad Unit IDs for development
  static const String _testBannerAndroid = "ca-app-pub-3940256099942544/6300978111";
  static const String _testBannerIOS = "ca-app-pub-3940256099942544/2934735716";
  static const String _testInterstitialAndroid = "ca-app-pub-3940256099942544/1033173712";
  static const String _testInterstitialIOS = "ca-app-pub-3940256099942544/4411468910";
  static const String _testRewardedAndroid = "ca-app-pub-3940256099942544/5224354917";
  static const String _testRewardedIOS = "ca-app-pub-3940256099942544/1712485313";

  // Production Ad Unit IDs
  static const String _prodBanner = "ca-app-pub-6747402245276233/5423106938";
  static const String _prodInterstitial = "ca-app-pub-6747402245276233/5039963550";
  static const String _prodRewarded = "ca-app-pub-6747402245276233/9059099616";
  static const String _prodCommonBanner = "ca-app-pub-6747402245276233/7888121190";
  static const String _prodResultInterstitial = "ca-app-pub-6747402245276233/5178370755";

  // Set to true for production release, false for testing
  static const bool _isProduction = false;

  static String get bannerUnitID {
    if (_isProduction) return _prodBanner;
    return Platform.isIOS ? _testBannerIOS : _testBannerAndroid;
  }

  static String get interstialUnitID {
    if (_isProduction) return _prodInterstitial;
    return Platform.isIOS ? _testInterstitialIOS : _testInterstitialAndroid;
  }

  static String get rewaredeUnitID {
    if (_isProduction) return _prodRewarded;
    return Platform.isIOS ? _testRewardedIOS : _testRewardedAndroid;
  }

  static String get common_bannerUnitID {
    if (_isProduction) return _prodCommonBanner;
    return Platform.isIOS ? _testBannerIOS : _testBannerAndroid;
  }

  static String get result_InterstialID {
    if (_isProduction) return _prodResultInterstitial;
    return Platform.isIOS ? _testInterstitialIOS : _testInterstitialAndroid;
  }
}