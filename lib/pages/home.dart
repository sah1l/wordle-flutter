import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:hive/hive.dart';
import 'package:wordle/models/result_object.dart';
import 'package:wordle/models/result_status.dart';
import 'package:wordle/utils/ad_helper.dart';
import 'package:wordle/utils/constants.dart';
import 'package:wordle/utils/data_ops.dart';
import 'package:wordle/utils/extensions.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    print('called');
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('Loaded banner ad');
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
    _loadInterstitialAd();
    super.initState();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pushNamed(context, '/random');
              _loadInterstitialAd();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
        maximumSize: const Size(700, 1000),
        enabled: kIsWeb,
        builder: (context) {
          return Material(
              child: SafeArea(
                  child: HiveListener(
                      box: Hive.box<ResultObject>(hiveDailyDataField),
                      builder: (box) {
                        ResultObject? recentDailyData =
                            DataOperations.getRecentDailyData();
                        ResultStatus? recentStatus;
                        Duration? duration;
                        DateTime now = DateTime.now();
                        if (recentDailyData != null) {
                          if (recentDailyData.status ==
                              ResultStatus.INCOMPLETE) {
                            recentStatus = ResultStatus.INCOMPLETE;
                          } else if (recentDailyData.endTime!.isSameDate(now)) {
                            recentStatus = recentDailyData.status;
                            duration =
                                DateTime(now.year, now.month, now.day + 1)
                                    .difference(now);
                          }
                        }
                        return Column(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 30),
                                child: Text("WORDLES",
                                    style:
                                        Theme.of(context).textTheme.headline3)),
                            const SizedBox(
                                width: 60,
                                child: Image(image: AssetImage('assets/icon/W_512x512.png'), width: 50,)),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Center(
                                    child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Card(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/daily');
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "DAILY PUZZLE",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            const Text(
                                                "See how well you do for the word of the day"),
                                            recentStatus ==
                                                    ResultStatus.INCOMPLETE
                                                ? const Text(
                                                    "In progress",
                                                    style: TextStyle(
                                                        color: Colors.amber),
                                                  )
                                                : recentStatus ==
                                                        ResultStatus.SUCCESS
                                                    ? const Text("Completed",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green))
                                                    : recentStatus ==
                                                            ResultStatus.FAILURE
                                                        ? Text("Failed",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .error))
                                                        : Text(
                                                            "New Word Available",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                            duration != null
                                                ? TweenAnimationBuilder<
                                                        Duration>(
                                                    duration: duration,
                                                    tween: Tween(
                                                        begin: duration,
                                                        end: Duration.zero),
                                                    onEnd: () {
                                                      duration = null;
                                                      setState(() {});
                                                    },
                                                    builder:
                                                        (BuildContext context,
                                                            Duration value,
                                                            Widget? child) {
                                                      final hours = value
                                                          .inHours
                                                          .toString()
                                                          .padLeft(2, '0');
                                                      final minutes =
                                                          (value.inMinutes % 60)
                                                              .toString()
                                                              .padLeft(2, '0');
                                                      final seconds =
                                                          (value.inSeconds % 60)
                                                              .toString()
                                                              .padLeft(2, '0');
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          child: Text(
                                                            'Next Puzzle: $hours:$minutes:$seconds',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ));
                                                    })
                                                : const SizedBox.shrink(),
                                          ],
                                        )),
                                  )),
                                ))),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Center(
                                    child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Card(
                                      child: InkWell(
                                    onTap: () {
                                      if (_isInterstitialAdReady &&
                                          DataOperations.getRandomData()
                                                  .toList()
                                                  .length >=
                                              0 &&
                                          Random().nextBool() &&
                                          DataOperations.getRecentRandomData()
                                                  .status !=
                                              ResultStatus.INCOMPLETE) {
                                        _interstitialAd?.show();
                                      } else {
                                        Navigator.pushNamed(context, '/random');
                                      }
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "RANDOM PUZZLE",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            const Text(
                                                "Play as many times you wish"),
                                          ],
                                        )),
                                  )),
                                ))),
                            Spacer(),
                            if (_isBannerAdReady)
                              SizedBox(
                                width: _bannerAd.size.width.toDouble(),
                                height: _bannerAd.size.height.toDouble(),
                                child: AdWidget(ad: _bannerAd),
                              ),
                          ],
                        );
                      })));
        });
  }
}
