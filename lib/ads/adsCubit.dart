import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mathchamp/ads/unitIds.dart';

import 'adsState.dart';


class AdCubit extends Cubit<AdsState> {
  int _navigationCount = 0; // For Interstitial & Rewarded

  AdCubit() : super(AdsState.initial()) {
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
    loadCommonBannerAd();
    loadResultInterstitialAd();
  }

  // ---------------- Banner ----------------
  void loadBannerAd() {
    final banner = BannerAd(
      adUnitId: UnitIds.bannerUnitID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          emit(state.copyWith(bannerAd: ad as BannerAd)); // listener ka ad object use karo
        },
        onAdFailedToLoad: (_, __) => emit(state.copyWith(bannerAd: null)),
      ),
    );

    banner.load();
  }
  void loadCommonBannerAd() {
    final common_banner_ad = BannerAd(
      adUnitId: UnitIds.common_bannerUnitID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          emit(state.copyWith(common_bannerAd: ad as BannerAd)); // listener ka ad object use karo
        },
        onAdFailedToLoad: (_, __) => emit(state.copyWith(common_bannerAd: null)),
      ),
    );

    common_banner_ad.load();
  }


  // ---------------- Interstitial ----------------
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: UnitIds.interstialUnitID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => emit(state.copyWith(interstitialAd: ad)),
        onAdFailedToLoad: (_) => emit(state.copyWith(interstitialAd: null)),
      ),
    );
  }

  void showInterstitial(VoidCallback onComplete) {
    _navigationCount++;
    print("The navigationCount is ${_navigationCount}");
    if (_navigationCount % 3 != 0 || state.interstitialAd == null) {
      onComplete();
      return;
    }

    emit(state.copyWith(isLoadingInterstitial: true));

    state.interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
        emit(state.copyWith(isLoadingInterstitial: false));
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadInterstitialAd();
        emit(state.copyWith(isLoadingInterstitial: false));
        onComplete();
      },
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      state.interstitialAd?.show();
    });
  }

  // ---------------- Rewarded ----------------
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: UnitIds.rewaredeUnitID,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => emit(state.copyWith(rewardedAd: ad)),
        onAdFailedToLoad: (_) => emit(state.copyWith(rewardedAd: null)),
      ),
    );
  }

  void showRewardedAd(Function(int) onRewardEarned) {
    final rewardedAd = state.rewardedAd;
    if (rewardedAd != null) {
      rewardedAd.show(
        onUserEarnedReward: (ad, reward) => onRewardEarned(reward.amount.toInt()),
      );
      loadRewardedAd();
    } else {
      onRewardEarned(0); // fallback
    }
  }

  void loadResultInterstitialAd() {
    InterstitialAd.load(
      adUnitId: UnitIds.result_InterstialID,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => emit(state.copyWith(result_interstitialAd: ad)),
        onAdFailedToLoad: (_) => emit(state.copyWith(result_interstitialAd: null)),
      ),
    );
  }

  void showResultInterstitial() {

    emit(state.copyWith(isLoadingResultInterstitial: true));

    state.result_Interstial!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadResultInterstitialAd();
        emit(state.copyWith(isLoadingResultInterstitial: false));
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadResultInterstitialAd();
        emit(state.copyWith(isLoadingResultInterstitial: false));
      },
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      state.result_Interstial?.show();
    });
  }

}
