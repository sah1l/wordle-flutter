import 'package:flutter/material.dart';
import 'package:wordle/components/keyboard/layout.dart';

class TextKey extends StatelessWidget {
  const TextKey({
    Key? key,
    required this.text,
    required this.onTextInput,
    required this.background,
    // required this.repeated,
    this.flex = 1,
  }) : super(key: key);
  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;
  final Color background;

  // final bool repeated;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: text == ''
            ? null
            : Material(
                color: background,
                child: InkWell(
                  onTap: () async {
                    onTextInput.call(text);
                  },
                  child: Center(
                    child: text == TextInputLayout.BACKSPACE
                        ? const Icon(
                            Icons.backspace,
                            color: Colors.white,
                          )
                        : Text(
                            text,
                            style: TextStyle(
                                // decoration: repeated ? TextDecoration.underline : null,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize:
                                    text == TextInputLayout.ENTER ? 14 : 18),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
