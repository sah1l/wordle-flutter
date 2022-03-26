import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:wordle/pages/game_screen.dart';
import 'package:wordle/pages/help_dialog.dart';
import 'package:wordle/pages/stats_dialog.dart';
import 'package:wordle/utils/data_ops.dart';
import 'package:wordle/models/result_object.dart';
import 'package:wordle/models/result_status.dart';
import 'package:wordle/utils/spell_apis.dart';

class WordleRandom extends StatefulWidget {
  const WordleRandom({Key? key}) : super(key: key);

  @override
  _WordleRandomState createState() => _WordleRandomState();
}

class _WordleRandomState extends State<WordleRandom> {
  String actualWord = '';

  @override
  void initState() {
    super.initState();
    List<ResultObject> data = DataOperations.getRandomData().toList();
    if (data.isEmpty ||
        data[data.length - 1].status != ResultStatus.INCOMPLETE) {
      setActualWord();
    } else {
      ResultObject res = data[data.length - 1];
      actualWord = res.actualWord;
    }
  }

  void setActualWord() {
    actualWord = SpellApis().getRandomWord(5).toUpperCase();
    ResultObject result = ResultObject(
        actualWord: actualWord,
        guessedWords: ['', '', '', '', '', ''],
        status: ResultStatus.INCOMPLETE,
        startTime: DateTime.now());
    DataOperations.addRandomData(result);
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
                            await showStatsDialog(
                                context,
                                "Random Puzzle Stats",
                                DataOperations.getRandomData);
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
                    getRecentData: DataOperations.getRecentRandomData,
                    getAllDataFn: DataOperations.getRandomData,
                  ));
        });
  }
}
