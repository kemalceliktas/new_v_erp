// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderFinishModelAdapter extends TypeAdapter<OrderFinishModel> {
  @override
  final int typeId = 22;

  @override
  OrderFinishModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderFinishModel(
      id: fields[0] as String?,
      barcode: fields[1] as String?,
      cari: fields[3] as String?,
      price: fields[2] as String?,
      brand: fields[4] as String?,
      kategori: fields[5] as String?,
      adet: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderFinishModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.barcode)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.cari)
      ..writeByte(4)
      ..write(obj.brand)
      ..writeByte(5)
      ..write(obj.kategori)
      ..writeByte(6)
      ..write(obj.adet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderFinishModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
