import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      print("returning this");
      return 'ca-app-pub-1589337416363055/6469824406';
      // return 'ca-app-pub-3940256099942544/6300978111';
    // } else if (Platform.isIOS) {
    //   return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1589337416363055/9070091103';
      // return 'ca-app-pub-3940256099942544/1033173712';
    // } else if (Platform.isIOS) {
    //   return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}