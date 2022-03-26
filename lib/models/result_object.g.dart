// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultObjectAdapter extends TypeAdapter<ResultObject> {
  @override
  final int typeId = 0;

  @override
  ResultObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResultObject(
      actualWord: fields[0] as String,
      guessedWords: (fields[1] as List).cast<String>(),
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      status: fields[4] as ResultStatus,
    );
  }

  @override
  void write(BinaryWriter writer, ResultObject obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.actualWord)
      ..writeByte(1)
      ..write(obj.guessedWords)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
