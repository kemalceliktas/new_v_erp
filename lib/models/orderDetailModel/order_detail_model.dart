import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OrderDetailFields {
  static const String orderId = "orderId";
  static const String barcodes = "barcodes";
  static const String prices = "prices";
  static const String quantity = "quantity";
  static const String isPaid = "isPaid";
  static const String brands = "brands";
  static const String categorys = "categorys";
  static const String cari = "cari";
  static const String date = "date";
  static const String isArchive = "isArchive";
  static const String status = "status";
  static const String type = "type";
  static List<dynamic> getFields() => [
        orderId,
        barcodes,
        prices,
        quantity,
        isPaid,
        brands,
        categorys,
        cari,
        date,
        isArchive,
        status,
        type
      ];
}

// ignore: must_be_immutable
class OrderDetailModel extends Equatable {
  String? orderId;
  String? barcodes;
  String? prices;
  String? quantity;
  String? ispaid;
  String? brands;
  String? categorys;
  String? cari;
  String? date;
  String? isArchive;
  String? status;
  String? type;

  OrderDetailModel({
    required this.orderId,
    required this.barcodes,
    required this.prices,
    required this.quantity,
    required this.ispaid,
    required this.brands,
    required this.categorys,
    required this.cari,
    required this.date,
    required this.isArchive,
    required this.status,
    required this.type,
  });

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json["orderId"];
    barcodes = json["barcodes"];
    prices = json["prices"];
    quantity = json["quantity"];
    ispaid = json["isPaid"];
    brands = json["brands"];
    categorys = json["categorys"];
    cari = json["cari"];
    date = json["date"];
    isArchive=json["isArchive"];
    status=json["status"];
    type=json["type"];
  }

  Map<String, dynamic> toJson() => {
        OrderDetailFields.orderId: orderId ?? const Uuid().v4(),
        OrderDetailFields.brands: brands,
        OrderDetailFields.barcodes: barcodes,
        OrderDetailFields.cari: cari,
        OrderDetailFields.categorys: categorys,
        OrderDetailFields.isPaid: ispaid,
        OrderDetailFields.prices: prices,
        OrderDetailFields.quantity: quantity,
        OrderDetailFields.date: date,
        OrderDetailFields.isArchive:isArchive,
        OrderDetailFields.status:status,
        OrderDetailFields.type:type,
      };
  String get formattedDate {
   

   if (date == null) return 'tarih yok';

   DateTime dateTime = DateTime.parse(date.toString());
String formattedDate = DateFormat('dd MMMM EEEE y', 'tr_TR').format(dateTime);
  return formattedDate;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [orderId,status,categorys,cari,brands];
}
