import 'dart:developer';

import 'package:erp_project/models/orderModel/order_model.dart';
import 'package:erp_project/models/productModel/product_model.dart';
import 'package:flutter/material.dart';

import '../../service/user_sheet_api.dart';

class ProductProvider extends ChangeNotifier {
  final formGlobalKey = GlobalKey<FormState>();
  ProductModel? product;
  List<ProductModel?> productList = [];
  bool isLoading = false;

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<ProductModel?>> getAllProduct() async {
    try {
      final product = await UserSheetsApi.getAllProduct();

      if (product.isEmpty) {
        return [];
      } else {
        productList = product;
        notifyListeners();

        return productList;
      }
    } catch (e) {
      inspect(e.toString());

      return [];
    }
  }

  void addProduct(
      {required ProductModel productModel,
      required BuildContext context}) async {
    changeLoading();
    product = productModel;
    productList.add(product);
    // changeLoading();
    await getAllProduct();

    notifyListeners();
    changeLoading();
  }

  Future<bool> deleteProduct({required String id}) async {
    changeLoading();

    final result = await UserSheetsApi.deleteProduct(id);
    if (result) {
      await getAllProduct();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }
}
