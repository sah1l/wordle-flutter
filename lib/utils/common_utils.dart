import 'package:wordle/models/result_object.dart';
import 'package:wordle/models/result_status.dart';
import 'package:wordle/utils/data_ops.dart';

class CommonUtils {
  static createShareString(int index, ResultObject obj) {
    if (obj.status != ResultStatus.SUCCESS) {
      return null;
    }
    String incorrect = '⬛';
    String correct = '🟩';
    String included = '🟨';
    List<String> guessedWords = obj.guessedWords;
    String actualWord = obj.actualWord;

    String result =
        'Wordle #${index} ${guessedWords.indexOf(actualWord.toUpperCase()) + 1}/${guessedWords.length}\n\n';
    for (String word in guessedWords) {
      List<int>.generate(word.length, (int index) => index).forEach((index) {
        if (actualWord[index] == word[index]) {
          result += correct;
        } else if (actualWord.contains(word[index])) {
          result += included;
        } else {
          result += incorrect;
        }
      });
      result += '\n';
    }
    return result;
  }

  bool isFirstTime() {
    if(DataOperations.getDailyData().toList().isEmpty &&
        DataOperations.getRandomData().toList().isEmpty){
      return true;
    }
    return false;
  }
}
