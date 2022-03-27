import 'package:flutter/material.dart';
import 'package:wordle/components/word_row.dart';

Future<void> showHelpDialog(context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('HOW TO PLAY')),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(children: <Text>[
                    Text("Guess the word in "),
                    Text("6 tries",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ])),
              const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text('Each guess must be a valid 5 letter word. '
                      'Hit the enter button to submit.')),
              const Text(
                  'After each guess is submitted, the color of the tiles will change '
                  'to show how close your guess was to the word.'),
              const Divider(
                color: Colors.black,
                height: 20,
              ),
              RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                    TextSpan(text: "For example, let's suppose "),
                    TextSpan(
                        text: "HELLO",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " is the actual word we need to guess. And we enter the below words as our guess.")
                  ])),
              const WordRowWidget(
                wordSubmitted: true,
                actualWord: 'hello',
                guessWord: 'world',
              ),
              RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                    TextSpan(text: "The letter "),
                    TextSpan(
                        text: "L",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " is in the word and at the same spot")
                  ])),
              RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                    TextSpan(text: "The letter "),
                    TextSpan(
                        text: "O",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " is in the word but at the different spot")
                  ])),
              const WordRowWidget(
                wordSubmitted: true,
                actualWord: 'hello',
                guessWord: 'bleed',
              ),
              RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                    TextSpan(text: "Here only one "),
                    TextSpan(
                        text: "E",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: " is highlighted, that means there is only one "),
                    TextSpan(
                        text: "E",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " in the actual word.")
                  ])),
              const WordRowWidget(
                wordSubmitted: true,
                actualWord: 'hello',
                guessWord: 'small',
              ),
              RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: const [
                    TextSpan(text: "Here both the "),
                    TextSpan(
                        text: "L",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: " are highlighted, that means there are two "),
                    TextSpan(
                        text: "L",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            " in the actual word. And one of them is green so position of one "),
                    TextSpan(
                        text: "L",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " is also correct.")
                  ])),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
