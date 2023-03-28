import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'order_model.g.dart'; 

// flutter packages pub run build_runner build

@HiveType(typeId: 22)
class OrderFinishModel extends HiveObject with EquatableMixin{
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? barcode;
  @HiveField(2)
  final String? price;
  @HiveField(3)
  final String? cari;
  @HiveField(4)
  final String? brand;
  @HiveField(5)
  final String? kategori;
  @HiveField(6)
  final String? adet;
 

  OrderFinishModel({required this.id,required this.barcode,required this.cari,required this.price,required this.brand,required this.kategori,required this.adet});


  @override
  List<Object?> get props => [id,barcode,brand,kategori,cari,price,];
}



 