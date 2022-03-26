import 'package:hive/hive.dart';

part 'result_status.g.dart';

@HiveType(typeId: 1)
enum ResultStatus {
  @HiveField(0)
  SUCCESS,
  @HiveField(1)
  FAILURE,
  @HiveField(2)
  INCOMPLETE
}
