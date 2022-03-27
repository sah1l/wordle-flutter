import 'package:flutter/material.dart';
import 'package:wordle/components/keyboard/keyboard.dart';
import 'package:wordle/components/keyboard/layout.dart';
import 'package:wordle/components/word_row.dart';
import 'package:wordle/models/result_object.dart';
import 'package:wordle/models/result_status.dart';
import 'package:wordle/pages/stats_dialog.dart';
import 'package:wordle/utils/common_utils.dart';
import 'package:wordle/utils/data_ops.dart';
import 'package:wordle/utils/spell_apis.dart';

class GameScreen extends StatefulWidget {
  const GameScreen(
      {Key? key,
      required this.actualWord,
      required this.getRecentData,
      required this.getAllDataFn,
      this.isDaily = false})
      : super(key: key);
  final String actualWord;
  final Function getRecentData;
  final Function getAllDataFn;
  final bool isDaily;

  @override
  State<StatefulWidget> createState() => _GameScreen();
}

class _GameScreen extends State<GameScreen> {
  List<String>? guessedWords =
      DataOperations.getRecentRandomData()?.guessedWords;
  int currentIndex =
      DataOperations.getRecentRandomData()?.guessedWords?.indexOf('') ?? 0;
  bool failed = false;
  bool _isButtonTapped = false;

  @override
  void initState() {
    super.initState();
    guessedWords = widget.getRecentData().guessedWords;
    currentIndex = widget.getRecentData().guessedWords.indexOf('');
    if (currentIndex == -1) {
      currentIndex = guessedWords!.length;
    }
  }

  onKeyboardKeyPress(String key) async {
    if (_isButtonTapped) {
      return;
    }
    if (currentIndex >= guessedWords!.length ||
        (currentIndex != 0 &&
            guessedWords![currentIndex - 1] == widget.actualWord)) {
      return;
    }
    String cw = guessedWords![currentIndex];
    if (key == TextInputLayout.BACKSPACE) {
      if (cw.isEmpty) {
        return;
      }
      cw = cw.substring(0, cw.length - 1);
      guessedWords![currentIndex] = cw;
    } else if (key == TextInputLayout.ENTER) {
      if (cw.length < 5) {
        return;
      } else {
        _isButtonTapped = true;
        setState(() {});
        bool valid = SpellApis().validateWord(cw);
        if (valid) {
          ResultObject res = widget.getRecentData();
          res.guessedWords = guessedWords!;
          if (guessedWords![currentIndex] == widget.actualWord) {
            res.endTime = DateTime.now();
            res.status = ResultStatus.SUCCESS;
            showStatsDialog(
                context, "You guessed it right", widget.getAllDataFn,
                share: widget.isDaily
                    ? CommonUtils.createShareString(
                        widget
                            .getRecentData()
                            .startTime
                            .difference(DateTime(2022, 1, 29))
                            .inDays,
                        widget.getRecentData())
                    : null);
          } else if (currentIndex == guessedWords!.length - 1) {
            res.endTime = DateTime.now();
            res.status = ResultStatus.FAILURE;
            failed = true;
          } else {
            res.status = ResultStatus.INCOMPLETE;
          }
          res.save();
          currentIndex++;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 300),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                right: 100,
                left: 100,
                bottom: MediaQuery.of(context).size.height / 4 + 20),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            content: Text(
              "Not a valid word",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ));
        }
      }
    } else {
      if (cw.length < 5) {
        cw += key;
      }
      guessedWords![currentIndex] = cw;
    }
    _isButtonTapped = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (currentIndex < guessedWords!.length) {
            ResultObject res = widget.getRecentData();
            guessedWords![currentIndex] = '';
            res.guessedWords = guessedWords!;
            res.save();
          }
          return true;
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: Column(children: [
              for (int i = 0; i < guessedWords!.length; i++)
                WordRowWidget(
                  actualWord: widget.actualWord,
                  guessWord: guessedWords![i],
                  wordSubmitted: i < currentIndex,
                ),
              if (!failed) const Spacer(),
              failed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("Correct word was")),
                        Text(
                          widget.actualWord,
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ],
                    )
                  : VirtualKeyboard(
                      actualWord: widget.actualWord,
                      guessedWords:
                          guessedWords!.getRange(0, currentIndex).toList(),
                      onTextInput: onKeyboardKeyPress,
                    )
            ])));
  }
}
