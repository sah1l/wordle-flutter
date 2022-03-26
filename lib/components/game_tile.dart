import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Evaluation {
  missing,
  correct,
  present,
}

class GameTileWidget extends StatelessWidget {
  const GameTileWidget(
      {Key? key,
      required this.letter,
      required this.evaluation,
      // required this.repeated,
      this.submitted = false})
      : super(key: key);

  final String letter;
  final Evaluation evaluation;
  final bool submitted;
  // final bool repeated;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: (MediaQuery.of(context).size.height * 2 / 4) / 6,
        decoration: BoxDecoration(
            color: letter.trim().isEmpty || !submitted
                ? Colors.transparent
                : evaluation == Evaluation.correct
                    ? Colors.green
                    : evaluation == Evaluation.present
                        ? Colors.amber
                        : Colors.grey,
            border: letter.trim().isEmpty || !submitted
                ? Border.all(color: Colors.grey)
                : null),
        child: Center(
            child: Text(
          letter.toUpperCase(),
          style: TextStyle(
              // decoration: repeated && submitted ? TextDecoration.underline : null,
              color: submitted ||
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 40),
        )));
  }
}
