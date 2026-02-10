import 'dart:math';
import 'package:flutter/services.dart';

class SpellApis {
  static List<String> allWords = [];
  static List<String> commonWords = [];
  static List<String> dailyWords = [];

  setAllWords() async {
    String words = await rootBundle.loadString('assets/words.txt');
    allWords = words.split("\n").map((e) => e.trim()).toList();
  }

  setCommonWords() async {
    String words = await rootBundle.loadString('assets/common.txt');
    commonWords = words.split("\n").map((e) => e.trim()).toList();
  }

  setDailyWords() async {
    String words = await rootBundle.loadString('assets/daily.txt');
    dailyWords = words.split("\n").map((e) => e.trim()).toList();
  }

  String getRandomWord(int nLetter) {
    final List<String> words =
        commonWords.where((element) => element.length == nLetter).toList();
    return words[Random().nextInt(words.length)];
  }

  String getDailyWord({DateTime? date}) {
    if (dailyWords.isEmpty) {
      return "HELLO"; // Fallback safety
    }
    final DateTime startDate = DateTime(2022, 2, 9);
    final int difference =
        (date ?? DateTime.now()).difference(startDate).inDays;
    return dailyWords[difference % dailyWords.length];
  }

  bool validateWord(String word) {
    return allWords.contains(word.toLowerCase());
  }
}
