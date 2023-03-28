import 'dart:collection';
import 'dart:developer';

import 'package:erp_project/models/orderDetailModel/order_detail_model.dart';
import 'package:erp_project/models/orderModel/order_model.dart';
import 'package:flutter/material.dart';

import '../../service/user_sheet_api.dart';

class OrderDetailProvider extends ChangeNotifier {
  List<OrderDetailModel>? currentOrder;
  List<OrderDetailModel> orderList = [];
  OrdeRModel? ordeRModel;
  List<OrdeRModel?> orderMainList = [];
  List<List<OrderDetailModel>> orderDetailList = [];
  bool isLoading = false;
  double total = 0.0;
  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  double orderTotal = 0.0;
  double orderPayment = 0.0;
  double orderNewTotal = 0.0;

  String? payme;

  List<OrderDetailModel>? getOrder(
      List<OrderDetailModel> model, OrdeRModel order) {
    orderTotal = calculateTotal(model, "");
    orderPayment = double.tryParse(order.ispaid.toString())!;
    orderNewTotal = orderTotal - orderPayment;

    return model;
  }

  void addPayment(String payment) {
    orderNewTotal -= double.tryParse(payment.toString())!;
    orderPayment = orderPayment += double.tryParse(payment.toString())!;
    total -= orderPayment;

    notifyListeners();
  }

  void createOrderDetail(List<OrderDetailModel> model, OrdeRModel order) {
    currentOrder = getOrder(model, order);
  }

  Future<List<OrdeRModel?>> getAllOrder() async {
    final orders = await UserSheetsApi.getAllOrders();

    if (orders.isEmpty) {
      return [];
    } else {
      orderMainList = orders;

      notifyListeners();

      return orderMainList;
    }
  }

  List<List<OrderDetailModel>> groupOrdersById() {
    final groups = SplayTreeMap<String, List<OrderDetailModel>>();

    for (final order in orderList) {
      if (!groups.containsKey(order.orderId.toString())) {
        groups[order.orderId.toString()] = [];
      }

      groups[order.orderId]!.add(order);
    }

    orderDetailList = groups.values.toList();
    return orderDetailList;
  }

  double calculateTotal(
    List<OrderDetailModel> listOrder,
    String? payment,
  ) {
    total = 0.0;

    for (OrderDetailModel model in listOrder) {
      if (model.prices!.isNotEmpty && model.quantity!.isNotEmpty) {
        total += double.tryParse(
                model.prices!.replaceAll(".", "").replaceAll(",", "."))! *
            double.tryParse(model.quantity.toString())!;
      }
    }

    if (payment!.isNotEmpty) {
      return total -= double.tryParse(payment)!.toDouble();
    }
    return total;
  }

  double calculateAraToplam(
    List<OrderDetailModel> listOrder,
  ) {
    total = 0.0;

    for (OrderDetailModel model in listOrder) {
      if (model.prices!.isNotEmpty && model.quantity!.isNotEmpty) {
        total += double.tryParse(
                model.prices!.replaceAll(".", "").replaceAll(",", "."))! *
            double.tryParse(model.quantity.toString())!;
      }
    }

    return total;
  }

  Future<List<OrderDetailModel?>>? getAllOrderDetails() async {
    try {
      final orders = await UserSheetsApi.getAllOrderDetails();

      if (orders.isEmpty) {
        notifyListeners();

        return [];
      } else {
        orderList = orders as List<OrderDetailModel>;
        groupOrdersById();
        notifyListeners();

        return orderList;
      }
    } catch (e) {
      inspect(e.toString());
      notifyListeners();

      return [];
    }
  }

  Future<bool> addOrderDetail(
      {required List<OrderDetailModel> orderModel,
      required BuildContext context}) async {
    changeLoading();

    orderList.addAll(orderModel);

    final test = await UserSheetsApi.insertOrderDetailToDataBase(orderModel)
        .then((value) async {
      return value;
    });
    if (test) {
      await getAllOrderDetails();
      notifyListeners();
      changeLoading();
      return true;
    }
    changeLoading();
    return false;
  }

  Future<bool> updateOrderDetails(
      {required String id, required String key, required dynamic value}) async {
    changeLoading();
    final result =
        await UserSheetsApi.updateOrderDetail(id: id, key: key, value: value);

    if (result) {
      await getAllOrderDetails();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }

  Future<bool> deleteOrderDetail({required String id}) async {
    changeLoading();

    final result = await UserSheetsApi.deleteOrderDetail(id);
    if (result) {
      await getAllOrderDetails();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }
}
