import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mathchamp/ads/unitIds.dart';

import 'adsState.dart';


class AdCubit extends Cubit<AdsState> {
  int _navigationCount = 0; // For Interstitial & Rewarded

  AdCubit() : super(AdsState.initial()) {
    // Banner ads are now managed by each screen widget (_HomeBannerAd,
    // _CommonBannerAd) to avoid the "AdWidget already in tree" crash.
    // Only interstitial / rewarded ads are pre-loaded here.
    loadInterstitialAd();
    loadRewardedAd();
    loadResultInterstitialAd();
  }

  // ---------------- Banner ----------------
  void loadBannerAd() {
    _loadAdaptiveBanner(
      unitId: UnitIds.bannerUnitID,
      onLoaded: (ad, size) => emit(state.copyWith(bannerAd: ad, bannerAdSize: size)),
      onFailed: () => emit(state.copyWith(bannerAd: null)),
    );
  }

  void loadCommonBannerAd() {
    _loadAdaptiveBanner(
      unitId: UnitIds.common_bannerUnitID,
      onLoaded: (ad, size) => emit(state.copyWith(common_bannerAd: ad, commonBannerAdSize: size)),
      onFailed: () => emit(state.copyWith(common_bannerAd: null)),
    );
  }

  /// Loads a banner using an anchored adaptive size for the current screen width.
  /// Falls back to [AdSize.banner] if the adaptive size cannot be determined.
  Future<void> _loadAdaptiveBanner({
    required String unitId,
    required void Function(BannerAd ad, AdSize size) onLoaded,
    required void Function() onFailed,
  }) async {
    AdSize adSize;
    try {
      // Get the logical screen width in dp. PlatformDispatcher.instance.views
      // is always available even without a BuildContext.
      final view = PlatformDispatcher.instance.implicitView;
      final widthPx = view?.physicalSize.width ?? 360;
      final dpr = view?.devicePixelRatio ?? 1.0;
      final widthDp = (widthPx / dpr).truncate();

      final adaptive = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        widthDp,
      );
      adSize = adaptive ?? AdSize.banner;
    } catch (_) {
      adSize = AdSize.banner;
    }

    final banner = BannerAd(
      adUnitId: unitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded(ad as BannerAd, adSize),
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          onFailed();
        },
      ),
    );

    banner.load();
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
    print("The navigationCount is $_navigationCount");
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
    final resultAd = state.result_Interstial;
    if (resultAd == null) {
      return;
    }
    emit(state.copyWith(isLoadingResultInterstitial: true));
        resultAd.fullScreenContentCallback = FullScreenContentCallback(
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
          resultAd.show();
        });
  }
}
