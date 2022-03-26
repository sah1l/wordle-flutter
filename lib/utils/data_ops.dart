import 'package:hive/hive.dart';
import 'package:wordle/utils/constants.dart';
import 'package:wordle/models/result_object.dart';

class DataOperations {
  static addDailyData(ResultObject result)   {
    Box<ResultObject> dailyData = Hive.box<ResultObject>(hiveDailyDataField);
    dailyData.add(result);
  }

  static getDailyData() {
    return Hive.box<ResultObject>(hiveDailyDataField).values;
  }

  static getRecentDailyData() {
    List<ResultObject> data =
        Hive.box<ResultObject>(hiveDailyDataField).values.toList();
    if(data.isEmpty){
      return null;
    }
    return data[data.length - 1];
  }

  static addRandomData(ResultObject result) {
    Box<ResultObject> randomData = Hive.box<ResultObject>(hiveRandomDataField);
    randomData.add(result);
  }

  static getRandomData() {
    return Hive.box<ResultObject>(hiveRandomDataField).values;
  }

  static getRecentRandomData() {
    List<ResultObject> data =
        Hive.box<ResultObject>(hiveRandomDataField).values.toList();
    if(data.isEmpty){
      return null;
    }
    return Hive.box<ResultObject>(hiveRandomDataField).getAt(data.length - 1);
  }
}
