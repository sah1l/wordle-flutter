import 'package:hive/hive.dart';
import 'package:wordle/models/result_status.dart';

part 'result_object.g.dart';
// flutter packages pub run build_runner build


@HiveType(typeId: 0)
class ResultObject extends HiveObject {
  @HiveField(0)
  String actualWord;

  @HiveField(1)
  List<String> guessedWords;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  ResultStatus status;

  ResultObject(
      {required this.actualWord,
      required this.guessedWords,
      required this.startTime,
      this.endTime,
      required this.status});
}
