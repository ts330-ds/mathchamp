import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsState {
  final BannerAd? bannerAd;
  final BannerAd? common_bannerAd;
  final InterstitialAd? interstitialAd;
  final RewardedAd? rewardedAd;
  final bool isLoadingInterstitial;

  const AdsState({
    this.bannerAd,
    this.interstitialAd,
    this.rewardedAd,
    this.common_bannerAd,
    this.isLoadingInterstitial = false,
  });

  factory AdsState.initial() => const AdsState();

  AdsState copyWith({
    BannerAd? bannerAd,
    BannerAd? common_bannerAd,
    InterstitialAd? interstitialAd,
    RewardedAd? rewardedAd,
    bool? isLoadingInterstitial,
  }) {
    return AdsState(
      bannerAd: bannerAd ?? this.bannerAd,
      common_bannerAd: common_bannerAd ?? this.common_bannerAd,
      interstitialAd: interstitialAd ?? this.interstitialAd,
      rewardedAd: rewardedAd ?? this.rewardedAd,
      isLoadingInterstitial: isLoadingInterstitial ?? this.isLoadingInterstitial,
    );
  }
}
