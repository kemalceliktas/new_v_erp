import 'package:erp_project/hive/HivetestModel/order_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveProvider extends ChangeNotifier {
  // ignore: prefer_typing_uninitialized_variables
  var box;
  String selectedCategory = "0";
  var items = [];
  double total = 0.0;
  int itemIndex = 0;

  void addItemIndex() {
    itemIndex += 1;
    notifyListeners();
  }

  void deincreaseIndex() {
    if (itemIndex <= 0) {
      itemIndex = 0;
    } else {
      itemIndex -= 1;
    }
    notifyListeners();
  }

  // ignore: prefer_typing_uninitialized_variables
  var selectedValue;

  final formGlobalKey = GlobalKey<FormState>();
  void getItems() async {
    box = await Hive.openBox('order_box'); // open box

    items = box.values
        .toList()
        .reversed
        .toList(); //reversed so as to keep the new data to the top
    calculateTotal();
    notifyListeners();
  }

  void calculateTotal() {
    total = 0.0;

    for (OrderFinishModel model in items.cast<OrderFinishModel>().toList()) {
      if (model.price!.isNotEmpty && model.adet!.isNotEmpty) {
        total += double.tryParse(
                model.price!.replaceAll(".", "").replaceAll(",", "."))! *
            double.tryParse(model.adet!)!;
      }
    }
    notifyListeners();
  }

  void clearHive() async {
    items.clear();
    notifyListeners();
  }

  void deleteItem(dynamic box, OrderFinishModel item) async {
    box = await Hive.openBox('order_box');
    box.delete(item.key);
    getItems();
    notifyListeners();
  }
}
