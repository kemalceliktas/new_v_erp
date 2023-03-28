import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StaticConst {
  // Static değerler
  final String phoneNumber = '0555-555-5555';
  final String emailAddress = 'info@mycompany.com';
  final String whatsappMessage = 'Merhaba, size bir sorum olacak.';

  // category name
  String categoryName({required String id}) {
    switch (id) {
      case "0":
        return "NOTLAR";
      case "1":
        return "BKM";
      case "2":
        return "KİTAPSEPETİ";
      case "3":
        return "İBB";
      case "4":
        return "İLANLAR";

      default:
        return "";
    }
  }

  String dateForPDF(String date) {
    DateTime dateTime = DateTime.parse(date.replaceAll(".", "-"));
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year.toString()}";
    return formattedDate;
  }

  String dateFormatTr(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        DateFormat('dd MMMM y EEEE', 'tr_TR').format(dateTime);
    return formattedDate;
  }

  String dateNewFormat(String date) {
    DateTime dateTime = DateTime.parse(date.replaceAll(".", "-"));
    String formattedDate =
        DateFormat('dd MMMM y EEEE', 'tr_TR').format(dateTime.toLocal());
    return formattedDate;
  }

  Future<dynamic> returnDialog(
      {required BuildContext context,
      required Function acceptFunc,
      required String message}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dikkat!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () => acceptFunc(),
            ),
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                // İptal butonuna tıklandığında yapılacak işlemler
                Navigator.of(context).pop(); // Alert Dialog'u kapat
              },
            ),
          ],
        );
      },
    );
  }

  String priceFormat(String deger) {
    String paraBirimi = "₺";

    var nf = NumberFormat.currency(
        locale: "tr_TR", symbol: paraBirimi, decimalDigits: 2);
    String sonuc = nf.format(double.parse(deger));
    return sonuc;
  }

  String paymentTypeString(String types) {
    if (types.toString() == "1") {
      return "Nakit";
    } else if (types.toString() == "2") {
      return "Kredi Kartı";
    } else if (types.toString() == "3") {
      return "Çek";
    } else {
      return "Nakit";
    }
  }
}

extension CurrencyFormatter on String {
  String toCurrency() {
    final number = double.tryParse(this);
    if (number == null) return this;
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    return format.format(number);
  }
}
