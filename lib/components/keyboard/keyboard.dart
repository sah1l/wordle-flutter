import 'package:flutter/material.dart';
import 'package:wordle/components/keyboard/key.dart';
import 'package:collection/collection.dart';

import 'layout.dart';

class VirtualKeyboard extends StatelessWidget {
  VirtualKeyboard({
    Key? key,
    required this.onTextInput,
    required this.actualWord,
    required this.guessedWords,
  }) : super(key: key);

  final ValueSetter<String> onTextInput;
  final String actualWord;
  final List<String> guessedWords;

  @override
  Widget build(BuildContext context) {
    List<String> correctWords = guessedWords
        .map((word) => word.characters
            .whereIndexed((index, value) => actualWord[index] == value)
            .toList())
        .expand((ele) => ele)
        .toList();

    List<String> wrongWords = guessedWords
        .map((word) => word.characters
            .where((value) => !actualWord.contains(value))
            .toList())
        .expand((ele) => ele)
        .toList();

    List<String> presentWords = guessedWords
        .map((word) => word.characters
            .where((value) => actualWord.contains(value))
            .toList())
        .expand((ele) => ele)
        .toList();

    return SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            for (final keys in TextInputLayout().letters)
              Expanded(
                  child: Row(
                children: [
                  for (final letter in keys)
                    TextKey(
                        text: letter,
                        // repeated: presentWords.contains(letter) &&
                        //     actualWord.indexOf(letter) !=
                        //         actualWord.lastIndexOf(letter),
                        background: correctWords.contains(letter)
                            ? Colors.green
                            : presentWords.contains(letter)
                                ? Colors.amber
                                : wrongWords.contains(letter)
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                        onTextInput: onTextInput,
                        flex: keys.contains(TextInputLayout.ENTER)
                            ? ([
                                TextInputLayout.ENTER,
                                TextInputLayout.BACKSPACE
                              ].contains(letter)
                                ? 3
                                : 2)
                            : [""].contains(letter)
                                ? 1
                                : 2)
                ],
              )),
          ],
        ));
  }
}
