import 'package:flutter/material.dart';

Future<void> showSkipDialog(BuildContext context, Function onAccept) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text('Skip this word?')),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to give up this round?\n'
                  'This will be counted in stats as a loss and break your winning streak.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              onAccept();
            },
          )
        ],
      );
    },
  );
}
