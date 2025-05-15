// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WormModelAdapter extends TypeAdapter<WormModel> {
  @override
  final int typeId = 1;

  @override
  WormModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WormModel(
      createdOn: fields[0] as int,
      createdByName: fields[4] as String,
      id: fields[2] as String,
      createdByUid: fields[1] as String,
      createdByEmail: fields[3] as String,
      isEnable: fields[5] as bool,
      locationImg: fields[6] as String,
      wormsImg: (fields[7] as List).cast<String>(),
      latLong: fields[8] as String,
      postalCode: fields[9] as String,
      country: fields[10] as String,
      administrativeArea: fields[11] as String,
      locality: fields[12] as String,
      note: fields[13] as String,
      audioUrl: fields[14] as String,
      search: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WormModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.createdOn)
      ..writeByte(1)
      ..write(obj.createdByUid)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.createdByEmail)
      ..writeByte(4)
      ..write(obj.createdByName)
      ..writeByte(5)
      ..write(obj.isEnable)
      ..writeByte(6)
      ..write(obj.locationImg)
      ..writeByte(7)
      ..write(obj.wormsImg)
      ..writeByte(8)
      ..write(obj.latLong)
      ..writeByte(9)
      ..write(obj.postalCode)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.administrativeArea)
      ..writeByte(12)
      ..write(obj.locality)
      ..writeByte(13)
      ..write(obj.note)
      ..writeByte(14)
      ..write(obj.audioUrl)
      ..writeByte(15)
      ..write(obj.search);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WormModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
