import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3250471665604059/3187849582';
    }
    return null;
  }

  static String? get interstitialAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3250471665604059/1870898484';
    }
    return null;
  }

  static String? get rewardAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3250471665604059/4488311205';
    }
    return null;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
    },
  );
}
