import 'package:erp_project/models/orderModel/order_model.dart';
import 'package:flutter/material.dart';

import '../../service/user_sheet_api.dart';

class OrderProvider extends ChangeNotifier {
  OrdeRModel? order;
  List<OrdeRModel?> orderList = [];
  bool isLoading = false;
  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<OrdeRModel?>> getAllOrder() async {
    final orders = await UserSheetsApi.getAllOrders();

    if (orders.isEmpty) {
      return [];
    } else {
      orderList = orders;

      notifyListeners();

      return orderList;
    }
  }

  void addOrder(
      {required OrdeRModel ordeRModel, required BuildContext context}) async {
    order = ordeRModel;
    await UserSheetsApi.insertOrderToDatabase([order!]);
    orderList.add(ordeRModel);
    // changeLoading();
    await getAllOrder();

    notifyListeners();
  }

  Future<bool> updatePayment(
      {required String id, required String key, required dynamic value}) async {
    changeLoading();
    final result =
        await UserSheetsApi.updatePayment(id: id, key: key, value: value);

    if (result) {
      await getAllOrder();
      notifyListeners();
      changeLoading();

      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }
}
