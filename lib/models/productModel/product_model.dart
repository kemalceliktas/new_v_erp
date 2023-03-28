import 'package:equatable/equatable.dart';

class ProductFields {
  static const String id="id";
  static const String title = "title";
  static const String barcode = "barcode";
  static const String description = "description";
  static const String price = "price";
  static const String openDate = "openDate";
  static const String brand = "brand";
  static const String category = "category";
  static const String cari = "cari";
  static const String status = "status";

  static List<dynamic> getFields() =>
      [id,title, barcode, description, price, openDate, brand, category, cari,status];
}

// ignore: must_be_immutable
class ProductModel extends Equatable {
  String? id;
  String? title;
  String? barcode;
  String? description;
  String? price;
  String? openDate;
  String? cari;
  String? brand;
  String? category;
  String? status;

  ProductModel({
    required this.id,
    required this.title,
    required this.barcode,
    required this.description,
    required this.price,
    required this.openDate,
    required this.cari,
    required this.brand,
    required this.category,
    required this.status,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id=json["id"];
    title = json["title"];
    barcode = json["barcode"];
    description = json["description"];
    price = json["price"];
    openDate = json["openDate"];
    cari = json["cari"];
    brand = json["brand"];
    category = json["category"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() => {
    ProductFields.id:id,
        ProductFields.title: title,
        ProductFields.barcode: barcode,
        ProductFields.brand: brand,
        ProductFields.cari: cari,
        ProductFields.category: category,
        ProductFields.description: description,
        ProductFields.price: price,
        ProductFields.openDate: openDate,
        ProductFields.status:status,
      };

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id,title, barcode, category, description, brand, cari,status];
}
