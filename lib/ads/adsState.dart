import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsState {
  final BannerAd? bannerAd;
  final AdSize? bannerAdSize;
  final BannerAd? common_bannerAd;
  final AdSize? commonBannerAdSize;
  final InterstitialAd? interstitialAd;
  final RewardedAd? rewardedAd;
  final InterstitialAd? result_Interstial;
  final bool isLoadingInterstitial;
  final bool isLoadingResultInterstitial;

  const AdsState({
    this.bannerAd,
    this.bannerAdSize,
    this.interstitialAd,
    this.rewardedAd,
    this.common_bannerAd,
    this.commonBannerAdSize,
    this.result_Interstial,
    this.isLoadingInterstitial = false,
    this.isLoadingResultInterstitial = false,
  });

  factory AdsState.initial() => const AdsState();

  AdsState copyWith({
    BannerAd? bannerAd,
    AdSize? bannerAdSize,
    BannerAd? common_bannerAd,
    AdSize? commonBannerAdSize,
    InterstitialAd? interstitialAd,
    RewardedAd? rewardedAd,
    InterstitialAd? result_interstitialAd,
    bool? isLoadingInterstitial,
    bool? isLoadingResultInterstitial,
  }) {
    return AdsState(
      bannerAd: bannerAd ?? this.bannerAd,
      bannerAdSize: bannerAdSize ?? this.bannerAdSize,
      common_bannerAd: common_bannerAd ?? this.common_bannerAd,
      commonBannerAdSize: commonBannerAdSize ?? this.commonBannerAdSize,
      interstitialAd: interstitialAd ?? this.interstitialAd,
      rewardedAd: rewardedAd ?? this.rewardedAd,
      result_Interstial: result_interstitialAd ?? result_Interstial,
      isLoadingInterstitial: isLoadingInterstitial ?? this.isLoadingInterstitial,
      isLoadingResultInterstitial: isLoadingResultInterstitial ?? this.isLoadingResultInterstitial,
    );
  }
}
