import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'data_model.g.dart'; 

// flutter packages pub run build_runner build

@HiveType(typeId: 10)
class DataModel extends HiveObject with EquatableMixin{
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final String? barcode;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? price;
  @HiveField(4)
  final DateTime? openDate;
  @HiveField(5)
  final String? cari;
  @HiveField(6)
  final String? brand;
  @HiveField(7)
  final String? category;

  DataModel({required this.title,required this.barcode,required this.description,required this.price,required this.openDate,required this.cari,required this.brand,required this.category});


  @override
  List<Object?> get props => [title,barcode,brand,category,cari,price,openDate,description];
}



 