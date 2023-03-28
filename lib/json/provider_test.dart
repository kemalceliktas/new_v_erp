/* import 'package:adonis_app/Utility/const.dart';
import 'package:adonis_app/models/folio.dart';
import 'package:adonis_app/models/set_accomodation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services.dart';

class UpdateFolioProvider extends ChangeNotifier {
  SetAccomodation _accomodation;
  bool isUpdated = false;
  List<DailyPrice> dailyPrices = [];
  double totalRoomPrice = 0.0;
  double totalPayments = 0.0;
  double balance = 0.0;
  double finalBalance = 0.0;
  double finalBalance2 = 0.0;
  double discount = 0.0;
  double extraTotal = 0.0;
  double amountTransferFromRoom = 0.0;
  double amountTransferToAccount = 0.0;
  double amountTransferToRoom = 0.0;
  int lastAddedPaymentId = 0;
  double currencyRate = 1;
  double usdRate = 1;
  double eurRate = 1;
  double gbpRate = 1;
  int currentCurrency = 1;
  bool isCheck = false;
  double get totalRoomPriceInOriginalCurrency => totalRoomPrice / currencyRate;

  SetAccomodation get currentAccomodation => _accomodation;

  bool get markedExit => _accomodation.status == "0";

  bool get isNew => _accomodation.checkInNo == "0";

  bool get areDatesAvailableToExit =>
      DateFormat('dd.MM.yyyy')
          .parse(Const.sharedRef.getString('systemDate'))
          .compareTo(
              DateFormat('dd.MM.yyyy').parse(_accomodation.checkOutDate)) ==
      0;

  void markAsExit() {
    _accomodation.status = "0";
    notifyListeners();
  }

  void cancelExit() {
    _accomodation.status = "1";
    notifyListeners();
  }
  void deleteTransferRoom() {
    print("deleteTransfer");
    amountTransferToRoom=0.0;
    print(amountTransferToRoom);
    _newCalculateSummary();
    notifyListeners();
  }

  void _newCalculateSummary() {
    print("WORKK");
    totalRoomPrice = 0.0;
    print(_accomodation.priceCode.toString() + "PRİCE CODEEE");
    switch (_accomodation.priceCode) {
      case "99999":
        totalRoomPrice =
            Const.stringToDouble(_accomodation.price) * currencyRate;
        break;
      case "99998":
        print(_accomodation.price + "ACCOMODOTİON PRİCE");
        print(
            dailyPrices.map((e) => e.price).toString() + "ACCOMODOTİON PRİCE");
        print(currencyRate.toString() + "ACCOMODOTİON PRİCE");
        for (final dailyPrice in dailyPrices) {
          totalRoomPrice +=
              Const.stringToDouble(dailyPrice.price) * currencyRate;
        }
        /*  totalRoomPrice = totalRoomPrice * _accomodation.customers.length; */
        break;
      case "0":
      default:
        for (final dailyPrice in dailyPrices) {
          totalRoomPrice +=
              Const.stringToDouble(dailyPrice.price) * currencyRate;
        }
        break;
    }
    totalPayments = 0.0;

    for (final payment in _accomodation.payments) {
      print(payment.toJson());
      totalPayments += payment.currency == 1
          ? Const.stringToDouble(payment.amount) * 1
          : payment.currency == 2
              ? Const.stringToDouble(payment.amount) *
                  (payment.eurRate != null
                      ? Const.stringToDouble(payment.eurRate)
                      : eurRate)
              : payment.currency == 3
                  ? Const.stringToDouble(payment.amount) *
                      (payment.usdRate != null
                          ? Const.stringToDouble(payment.usdRate)
                          : usdRate)
                  : payment.currency == 4
                      ? Const.stringToDouble(payment.amount) *
                          (payment.gbpRate != null
                              ? Const.stringToDouble(payment.gbpRate)
                              : gbpRate)
                      : null;
    }

    if (amountTransferFromRoom != 0.0 ||
        amountTransferToAccount != 0.0 ||
        amountTransferToRoom != 0) {
          print(_accomodation.payments.map((e) => e.amount));
      print(amountTransferToAccount.toString() + "amounttransferaccount");
      print(amountTransferToRoom.toString() + "amounttransferroom");
      print(amountTransferFromRoom.toString() + "amounttransferfromroom");
      
      balance = (totalRoomPrice + extraTotal) - (totalPayments);
     print(totalPayments.toString() + "TOTAL PAYMENTS");
      totalPayments = (totalPayments+amountTransferFromRoom)-(amountTransferToAccount+amountTransferToRoom)
        ;
      print(totalPayments.toString() + "TOTAL PAYMENTS");
      
    } else if (amountTransferFromRoom == 0.0) {
      
      print(amountTransferToRoom.toString()+"WORK HERE");
      balance = totalRoomPrice +
          extraTotal +
          amountTransferFromRoom -
          totalPayments -
          amountTransferToAccount -
          amountTransferToRoom;
    }
    /*  if ((balance<0&&balance>-5)||(balance>0 && balance<5)) {
      if ((discount<0&&discount>-5)||(discount>0 && discount<5)) {
        discount=balance.abs();
        print("HERE 1.");
      }else{
        print("HERE 2.");
        discount=discount+=balance;
      }
       if (discount<0||balance<0) {
         finalBalance = balance + discount.abs();
       }else{
        finalBalance = balance - discount.abs();
       }
    } else{
       finalBalance = balance - discount;
    }
    discount=discount.abs();
    if (balance<0&&balance>-5) {
      balance=balance.abs();
    } */

    finalBalance = balance - discount;

    finalBalance = double.tryParse(finalBalance.toStringAsFixed(2));

    /* finalBalance=finalBalance.abs();
     balance=balance.abs(); */
    if (finalBalance == -0.0) {
      finalBalance = 0;
    }
    print(finalBalance.toString() + "FİNAL BALANCE");
  }

//BAK BURAYA
  void _calculateSummary() {
    totalRoomPrice = 0.0;

    switch (_accomodation.priceCode) {
      case "99999":
        totalRoomPrice =
            Const.stringToDouble(_accomodation.price) * currencyRate;
        break;
      case "99998":
        for (final dailyPrice in dailyPrices) {
          totalRoomPrice +=
              Const.stringToDouble(_accomodation.price) * currencyRate;
        }

        totalRoomPrice = totalRoomPrice * _accomodation.customers.length;

        break;
      case "0":
      default:
        for (final dailyPrice in dailyPrices) {
          totalRoomPrice +=
              Const.stringToDouble(dailyPrice.price) * currencyRate;
        }
        break;
    }
    totalPayments = 0.0;
    for (final payment in _accomodation.payments) {
      totalPayments += payment.currency == 1
          ? Const.stringToDouble(payment.amount) * 1
          : payment.currency == 2
              ? Const.stringToDouble(payment.amount) *
                  (payment.eurRate != null
                      ? Const.stringToDouble(payment.eurRate)
                      : eurRate)
              : payment.currency == 3
                  ? Const.stringToDouble(payment.amount) *
                      (payment.usdRate != null
                          ? Const.stringToDouble(payment.usdRate)
                          : usdRate)
                  : payment.currency == 4
                      ? Const.stringToDouble(payment.amount) *
                          (payment.gbpRate != null
                              ? Const.stringToDouble(payment.gbpRate)
                              : gbpRate)
                      : null;
    }
    if (amountTransferFromRoom != 0.0 ||
        amountTransferToAccount != 0.0 ||
        amountTransferToRoom != 0) {
      balance = (totalRoomPrice + extraTotal) - ((totalPayments));

      //BAK BURAYAA TODO
      amountTransferFromRoom != 0
          ? totalPayments = totalPayments +
              (amountTransferToAccount + amountTransferFromRoom.abs())
          : totalPayments = totalPayments -
              (amountTransferToAccount + amountTransferFromRoom.abs());
    } else if (amountTransferFromRoom == 0.0) {
      balance = totalRoomPrice +
          extraTotal +
          amountTransferFromRoom -
          totalPayments -
          amountTransferToAccount -
          amountTransferToRoom;
    }

    finalBalance = balance - discount;
    finalBalance = double.tryParse(finalBalance.toStringAsFixed(2));
    print(finalBalance.toString() + "FİNAL BALANCEE");
  }

  void createAccomodation(
    Folio folio,
    String room,
    String roomId,
    String roomType,
    String roomTypeId,
  ) {
    if (room != null) {
      final today = DateFormat('dd.MM.yyyy')
          .parse(Const.sharedRef.getString('systemDate'));
      _accomodation = SetAccomodation(
        discount: "",
        currencyType: "1",
        checkInNo: "0",
        accountId: "0",
        checkInDate: DateFormat('dd.MM.yyyy').format(today),
        checkOutDate:
            DateFormat('dd.MM.yyyy').format(today.add(const Duration(days: 1))),
        customers: <Customer>[],
        deletedPayments: <Map<String, String>>[],
        note: "",
        payments: <Payment>[],
        roomTypeId: roomTypeId,
        price: "0,00",
        priceCode: "",
        reservationId: "0",
        roomId: roomId,
        status: "1",
        userId: Const.sharedRef.getString("userID"),
        room: room,
        roomType: roomType,
      );

      _updateDailyPrices(
          newDates: DateTimeRange(
              start: today, end: today.add(const Duration(days: 1))));
    } else {
      _accomodation = _convertFolioToSetAccomodation(folio);
      /*    print(_accomodation.price.toString() + "ACCOMODATION PRICE"); */
      _newCalculateSummary();
    }
  }

  void changeDates(DateTimeRange date) {
    final dates = DateTimeRange(
      start: date.start,
      end: date.end,
    );
    _accomodation.checkInDate = DateFormat('dd.MM.yyyy').format(dates.start);
    _accomodation.checkOutDate = DateFormat('dd.MM.yyyy').format(dates.end);

    _updateDailyPrices(newDates: dates);
    notifyListeners();
  }

  void changeDatesNew(DateTimeRange date) {
    final dates = DateTimeRange(
      start: date.start,
      end: date.end,
    );
    _accomodation.checkInDate = DateFormat('dd.MM.yyyy').format(dates.start);
    _accomodation.checkOutDate = DateFormat('dd.MM.yyyy').format(dates.end);

    _updateDailyPricesNew(newDates: dates);
    notifyListeners();
  }

//TODO deger eklenecek
  void updateRoomDetails(String newRoomId, String newRoomTypeId, String room,
      String roomType, String roomPrice, int priceCode, String currencyType) {
    _accomodation.roomId = newRoomId;
    _accomodation.roomTypeId = newRoomTypeId;
    _accomodation.room = room;
    _accomodation.roomType = roomType;
    _accomodation.price =
        NumberFormat.currency(decimalDigits: 2, locale: "TR_tr", symbol: "")
            .format(Const.stringToDouble(roomPrice));
    _accomodation.priceCode = priceCode.toString();
    _accomodation.currencyType = currencyType;
    currentCurrency = int.tryParse(currencyType);
    /* currencyRate=calculateCurrency(currencyType)  as double; */

    _updateDailyPrices(newPrice: _accomodation.price);

    notifyListeners();
  }

  void calculatePaymentCurrency(dynamic data) async {
    print(data["kurlar"]["gbp"].replaceAll(",", ".") + "TESTT");
    eurRate = double.tryParse(data["kurlar"]["eur"].replaceAll(",", "."));
    usdRate = double.tryParse(data["kurlar"]["usd"].replaceAll(",", "."));
    gbpRate = double.tryParse(data["kurlar"]["gbp"].replaceAll(",", "."));
    /*  print(data.toString()+"DATAAAA");
    print(currencyType.toString()+"TYPEE---");
    print("------------");
    print(data["kurlar"]["eur"].replaceAll(",",".").toString()+"TESTTT DOUBLE"); */
    /* if (int.tryParse(currencyType) == 1) {
      currencyRate = 1;
    } else if (int.tryParse(currencyType) == 2) {
      currencyRate =
          double.tryParse(data["kurlar"]["eur"].replaceAll(",", "."));
    } else if (int.tryParse(currencyType) == 3) {
      currencyRate =
          double.tryParse(data["kurlar"]["usd"].replaceAll(",", "."));
    } else if (int.tryParse(currencyType) == 4) {
      currencyRate =
          double.tryParse(data["kurlar"]["gbp"].replaceAll(",", "."));
    } else {
      currencyRate = 1;
    } */
  }

  void calculateCurrency(String currencyType, dynamic data) async {
    /* print(data["kurlar"]["gbp"].replaceAll(",", ".") + "TESTT"); */
    /*  print(data.toString()+"DATAAAA");
    print(currencyType.toString()+"TYPEE---");
    print("------------");
    print(data["kurlar"]["eur"].replaceAll(",",".").toString()+"TESTTT DOUBLE"); */
    if (int.tryParse(currencyType) == 1) {
      currencyRate = 1;
    } else if (int.tryParse(currencyType) == 2) {
      currencyRate =
          double.tryParse(data["kurlar"]["eur"].replaceAll(",", "."));
    } else if (int.tryParse(currencyType) == 3) {
      currencyRate =
          double.tryParse(data["kurlar"]["usd"].replaceAll(",", "."));
    } else if (int.tryParse(currencyType) == 4) {
      currencyRate =
          double.tryParse(data["kurlar"]["gbp"].replaceAll(",", "."));
    } else {
      currencyRate = 1;
    }
  }

  void addCustomer(Customer customer) {
    _accomodation.customers.add(customer);
    if (_accomodation.priceCode == "99998") {
      _calculateSummary();

      /*     _newCalculateSummary(); */
    }
    notifyListeners();
  }

  void updateCustomer(Customer customer, index) {
    _accomodation.customers[index] = customer;
    notifyListeners();
  }

  void deleteCustomer(int index) {
    _accomodation.customers.removeAt(index);
    if (_accomodation.priceCode == "99998") {
      _calculateSummary();
      /*  _newCalculateSummary(); */
    }
    notifyListeners();
  }

  void updateNote(String note) {
    _accomodation.note = note;
  }

  void addCurrency(double currencyRate) {}

  void addPayment(Payment payment) {
    lastAddedPaymentId--;
    _accomodation.payments.add(payment);
    _calculateSummary();
    /* _newCalculateSummary(); */
    notifyListeners();
  }

  void addDiscount(double newDiscount) {
    discount += newDiscount;
    _accomodation.discount = newDiscount.toString();
    _newCalculateSummary();
    notifyListeners();
  }

  void addPaymentNew(Payment payment) {
    lastAddedPaymentId--;
    _accomodation.payments.add(payment);

    _newCalculateSummary();
    notifyListeners();
  }

  void deletePayment(List<String> deletedPayments) {
    if (deletedPayments.isEmpty) {
      return;
    }
    for (final id in deletedPayments) {
      _accomodation.payments.removeWhere((element) => element.paymentId == id);
      if ((int.tryParse(id) ?? 0) > 0) {
        _accomodation.deletedPayments.add({'PaymentId': id});
      }
    }

    _calculateSummary();
    /* _newCalculateSummary(); */
    notifyListeners();
  }

  void deletePaymentNew(List<String> deletedPayments) {
    if (deletedPayments.isEmpty) {
      return;
    }
    for (final id in deletedPayments) {
      _accomodation.payments.removeWhere((element) => element.paymentId == id);
      if ((int.tryParse(id) ?? 0) > 0) {
        _accomodation.deletedPayments.add({'PaymentId': id});
      }
    }
    _newCalculateSummary();
    notifyListeners();
  }

  Future<SetFolioResult> save() async {
    if (_checkForDuplicateCustomerId()) {
      print("object");
      throw Exception();
    }
    try {
     

      return await Api.setFolio(_accomodation);
    } catch (e) {
      print("Error occured trying to save folio $e");
      return null;
    }
  }

  bool _checkForDuplicateCustomerId() {
    final oldGuests = _accomodation.customers
        .where((guest) => guest.customerId != '0')
        .toList();

    if (oldGuests.isEmpty) {
      return false;
    }

    for (var i = 0; i < oldGuests.length; i++) {
      for (var j = i + 1; j < oldGuests.length; j++) {
        if (oldGuests[i].customerId == oldGuests[j].customerId) {
          return true;
        }
      }
    }
    return false;
  }

  void _updateDailyPrices({DateTimeRange newDates, String newPrice}) {
    if (newPrice != null) {
      dailyPrices = dailyPrices
          .map(
            (e) => DailyPrice(date: e.date, price: newPrice),
          )
          .toList();
    } else {
      final newDailyPrices = <DailyPrice>[];
      final diff = newDates.duration.inDays == 0 ? 1 : newDates.duration.inDays;
      for (var i = 0; i < diff; i++) {
        newDailyPrices.add(
          DailyPrice(
            date: DateFormat('dd.MM.yyyy')
                .format(newDates.start.add(Duration(days: i))),
            //TODO DEĞİŞİKLİK
            price: _accomodation.price,
          ),
        );
      }
      dailyPrices = newDailyPrices;
    }
    _calculateSummary();
    /*  _newCalculateSummary(); */
  }

  void _updateDailyPricesNew({DateTimeRange newDates, String newPrice}) {
    if (newPrice != null) {
      dailyPrices = dailyPrices
          .map(
            (e) => DailyPrice(date: e.date, price: newPrice),
          )
          .toList();
    } else {
      final newDailyPrices = <DailyPrice>[];
      final diff = newDates.duration.inDays == 0 ? 1 : newDates.duration.inDays;
      for (var i = 0; i < diff; i++) {
        newDailyPrices.add(
          DailyPrice(
            date: DateFormat('dd.MM.yyyy')
                .format(newDates.start.add(Duration(days: i))),
            //TODO DEĞİŞİKLİK
            price: _accomodation.price,
          ),
        );
      }
      dailyPrices = newDailyPrices;
    }
    _newCalculateSummary();
  }

  double _getCurrencyRate(Folio folio) {
    print(folio.currency.toString() + "currency");
    switch (folio.currency) {
      case 1:
        return 1;
      case 2:
        return folio.eurRate;
      case 3:
        return folio.usdRate;
      case 4:
        return folio.gbpRate;
      default:
        return 1;
    }
  }

//PROBLEMLİ BÖLÜM
  SetAccomodation _convertFolioToSetAccomodation(Folio folio) {
    currentCurrency = folio.currency;
    dailyPrices = folio.dailyPrices;
    totalPayments = folio.payment;
    usdRate = folio.usdRate;
    eurRate = folio.eurRate;
    gbpRate = folio.gbpRate;
    currencyRate = _getCurrencyRate(folio);
    totalRoomPrice =
        folio.total * currencyRate /* *folio.customers.length.toDouble() */;
    amountTransferFromRoom = folio.amountTransferFromRoom;
    amountTransferToAccount = folio.amountTransferToAccount;
    amountTransferToRoom = folio.amountTransferToRoom;
    extraTotal = folio.extra;
    balance = totalRoomPrice - totalPayments;
    discount = folio.discount;
    finalBalance = balance - discount;
    finalBalance = double.tryParse(finalBalance.toStringAsFixed(2));
    return SetAccomodation(
      discount: discount.toString(),
      accountId: "0",
      checkInDate: folio.arrivalDate,
      checkInNo: folio.checkInNo,
      checkOutDate: folio.departureDate,
      customers: folio.customers,
      deletedPayments: [],
      note: folio.notes,
      payments: folio.payments,
      price: folio.price == 0
          ? folio.dailyPrices.first.price
          : folio.price.toString(),
      priceCode: folio.priceCode.toString(),
      reservationId: "0",
      roomId: folio.roomId,
      roomTypeId: folio.roomTypeId,
      status: folio.status,
      userId: "0",
      room: folio.room,
      roomType: folio.roomType,
      currencyType: currentCurrency.toString(),
    );
  }
}
 */