import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OrderFields {
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
  static const String paymentType = "paymentType";
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
        paymentType
      ];
}

// ignore: must_be_immutable
class OrdeRModel extends Equatable {
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
  String? paymentType;

  OrdeRModel({
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
    required this.paymentType,
  });

  OrdeRModel.fromJson(Map<String, dynamic> json) {
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
    paymentType=json["paymentType"];
  }

  Map<String, dynamic> toJson() => {
        OrderFields.orderId: orderId ?? const Uuid().v4(),
        OrderFields.brands: brands,
        OrderFields.barcodes: barcodes,
        OrderFields.cari: cari,
        OrderFields.categorys: categorys,
        OrderFields.isPaid: ispaid,
        OrderFields.prices: prices,
        OrderFields.quantity: quantity,
        OrderFields.date: date,
        OrderFields.isArchive:isArchive,
        OrderFields.status:status,
        OrderFields.paymentType:paymentType,
      };
  String get formattedDate {
    if (date == null) return 'tarih yok';

    final parts = date!.split('.');
    if (parts.length != 3) return date!;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return date!;

    try {
      final formatted =
          DateFormat('d MMMM y', 'tr_TR').format(DateTime(year, month, day));
      return formatted;
    } catch (e) {
      return date!;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [orderId,status,categorys,cari,brands];
}
