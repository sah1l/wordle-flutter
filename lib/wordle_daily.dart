import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:hive/hive.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:wordle/models/result_object.dart';
import 'package:wordle/models/result_status.dart';
import 'package:wordle/pages/game_screen.dart';
import 'package:wordle/pages/help_dialog.dart';
import 'package:wordle/pages/skip_dialog.dart';
import 'package:wordle/pages/stats_dialog.dart';
import 'package:wordle/utils/common_utils.dart';
import 'package:wordle/utils/constants.dart';
import 'package:wordle/utils/data_ops.dart';
import 'package:wordle/utils/extensions.dart';
import 'package:wordle/utils/spell_apis.dart';

class WordleDaily extends StatefulWidget {
  const WordleDaily({Key? key}) : super(key: key);

  @override
  _WordleDailyState createState() => _WordleDailyState();
}

class _WordleDailyState extends State<WordleDaily>
    with SingleTickerProviderStateMixin {
  String actualWord = '';
  bool isFirstTime = CommonUtils().isFirstTime();

  @override
  void initState() {
    super.initState();
    List<ResultObject> data = DataOperations.getDailyData().toList();
    if (data.isEmpty ||
        (data[data.length - 1].status != ResultStatus.INCOMPLETE) &&
            !data[data.length - 1].startTime.isSameDate(DateTime.now())) {
      setActualWord();
    } else {
      ResultObject res = data[data.length - 1];
      actualWord = res.actualWord;
    }

    if (isFirstTime) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        showHelpDialog(context);
      });
    }
  }

  void setActualWord() {
    String word = SpellApis().getDailyWord();
    actualWord = word.toString().toUpperCase();
    ResultObject result = ResultObject(
        actualWord: actualWord,
        guessedWords: ['', '', '', '', '', ''],
        status: ResultStatus.INCOMPLETE,
        startTime: DateTime.now());
    DataOperations.addDailyData(result);
    setState(() {});
  }

  void onSkip() {
    ResultObject currentGame = DataOperations.getRecentDailyData();
    currentGame.status = ResultStatus.SKIPPED;
    currentGame.endTime = DateTime.now();
    currentGame.save();
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
        maximumSize: Size(700, 1000),
        enabled: kIsWeb,
        builder: (context) {
          return actualWord.isEmpty
              ? const SizedBox.shrink()
              : HiveListener(
                  box: Hive.box<ResultObject>(hiveDailyDataField),
                  builder: (box) {
                    return Scaffold(
                        appBar: AppBar(
                          title: const Text("WORDLES"),
                          actions: [
                            IconButton(
                                onPressed: () async {
                                  await showStatsDialog(
                                      context,
                                      "Daily Puzzle Stats",
                                      DataOperations.getDailyData,
                                      share: CommonUtils.createShareString(
                                          DataOperations.getRecentDailyData()
                                              .startTime
                                              .difference(DateTime(2022, 1, 29))
                                              .inDays,
                                          DataOperations.getRecentDailyData()));
                                },
                                icon: const Icon(Icons.bar_chart_outlined)),
                            IconButton(
                                onPressed: () async {
                                  await showHelpDialog(context);
                                },
                                icon: const Icon(Icons.help_outline)),
                            if (DataOperations.getRecentDailyData().status ==
                                ResultStatus.INCOMPLETE)
                              IconButton(
                                  onPressed: () async {
                                    await showSkipDialog(context, onSkip);
                                  },
                                  icon: const Icon(Icons.skip_next_outlined))
                          ],
                        ),
                        body: GameScreen(
                            actualWord: actualWord,
                            getRecentData: DataOperations.getRecentDailyData,
                            getAllDataFn: DataOperations.getDailyData,
                            isDaily: true));
                  });
        });
  }
}
