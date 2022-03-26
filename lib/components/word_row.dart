import 'package:flutter/material.dart';
import 'package:wordle/components/game_tile.dart';
import 'package:collection/collection.dart';

class WordRowWidget extends StatelessWidget {
  const WordRowWidget(
      {Key? key,
      this.guessWord = '',
      required this.actualWord,
      this.wordSubmitted = false})
      : super(key: key);

  final String guessWord;
  final String actualWord;
  final bool wordSubmitted;

  @override
  Widget build(BuildContext context) {
    List<Evaluation> evaluations = List.filled(5, Evaluation.missing);
    List<bool> targetsTaken = List.filled(5, false);
    final String updatedGuessWord = guessWord.padRight(5, ' ');
    for (int i = 0; i < updatedGuessWord.length; i++) {
      if (actualWord[i] == updatedGuessWord[i]) {
        evaluations[i] = Evaluation.correct;
        targetsTaken[i] = true;
      }
    }
    for (int i = 0; i < updatedGuessWord.length; i++) {
      if (!actualWord.contains(updatedGuessWord[i]) ||
          evaluations[i] != Evaluation.missing) {
        continue;
      }
      int presentIndex = -1;
      for (int j = 0; j < actualWord.length; j++) {
        if (guessWord[i] == actualWord[j] && !targetsTaken[j]) {
          presentIndex = j;
          break;
        }
      }
      if (presentIndex == -1) {
        continue;
      }
      evaluations[i] = Evaluation.present;
      targetsTaken[presentIndex] = true;
    }
    return Row(
        children: List<int>.generate(5, (int index) => index)
            .map((int index) => Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: GameTileWidget(
                        letter: updatedGuessWord[index],
                        submitted: wordSubmitted,
                        // repeated: actualWord.indexOf(updatedGuessWord[index]) != actualWord.lastIndexOf(updatedGuessWord[index]),
                        evaluation: evaluations[index]))))
            .toList());
  }
}
