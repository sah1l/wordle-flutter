
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:wordle/models/result_object.dart';
import 'package:wordle/models/result_status.dart';
import 'package:wordle/pages/game_screen.dart';
import 'package:wordle/pages/help_dialog.dart';
import 'package:wordle/pages/stats_dialog.dart';
import 'package:wordle/utils/common_utils.dart';
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

  @override
  void initState() {
    super.initState();
    List<ResultObject> data = DataOperations.getDailyData().toList();
    if (data.isEmpty ||
        (data[data.length - 1].status != ResultStatus.INCOMPLETE) &&
            !data[data.length - 1].endTime!.isSameDate(DateTime.now())) {
      setActualWord();
    } else {
      ResultObject res = data[data.length - 1];
      actualWord = res.actualWord;
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

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
        maximumSize: Size(700, 1000),
        enabled: kIsWeb,
        builder: (context) {
          return actualWord.isEmpty
              ? const SizedBox.shrink()
              : Scaffold(
                  appBar: AppBar(
                    title: const Text("WORDLES"),
                    actions: [
                      IconButton(
                          onPressed: () async {
                            await showStatsDialog(context, "Daily Puzzle Stats",
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
                          icon: const Icon(Icons.help_outline))
                    ],
                  ),
                  body: GameScreen(
                      actualWord: actualWord,
                      getRecentData: DataOperations.getRecentDailyData,
                      getAllDataFn: DataOperations.getDailyData,
                      isDaily: true));
        });
  }
}
