// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultStatusAdapter extends TypeAdapter<ResultStatus> {
  @override
  final int typeId = 1;

  @override
  ResultStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ResultStatus.SUCCESS;
      case 1:
        return ResultStatus.FAILURE;
      case 2:
        return ResultStatus.INCOMPLETE;
      case 3:
        return ResultStatus.SKIPPED;
      default:
        return ResultStatus.SUCCESS;
    }
  }

  @override
  void write(BinaryWriter writer, ResultStatus obj) {
    switch (obj) {
      case ResultStatus.SUCCESS:
        writer.writeByte(0);
        break;
      case ResultStatus.FAILURE:
        writer.writeByte(1);
        break;
      case ResultStatus.INCOMPLETE:
        writer.writeByte(2);
        break;
      case ResultStatus.SKIPPED:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
