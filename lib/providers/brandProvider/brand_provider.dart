import 'dart:developer';

import 'package:erp_project/models/brandModel/brand_model.dart';
import 'package:flutter/material.dart';

import '../../service/user_sheet_api.dart';

class BrandProvider extends ChangeNotifier {
  final formGlobalKey = GlobalKey<FormState>();
  BrandModel? brandModel;
  List<BrandModel?> brandList = [];
  bool isLoading = false;

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<BrandModel?>>? getAllBrands() async {
    try {
      final brand = await UserSheetsApi.getAllBrand();

      if (brand.isEmpty) {
        notifyListeners();

        return [];
      } else {
        brandList = brand;

        notifyListeners();

        return brandList;
      }
    } catch (e) {
      inspect(e.toString());
      notifyListeners();

      return [];
    }
  }

  Future<bool> addBrand(
      {required BrandModel brandModel, required BuildContext context}) async {
    changeLoading();
    brandModel = brandModel;
    final test = await UserSheetsApi.insertBrandToDataBase([brandModel])
        .then((value) async {
      return value;
    });
    if (test) {
      await getAllBrands();
      notifyListeners();
      changeLoading();
      return true;
    }
    changeLoading();
    return false;
  }

  Future<bool> updateBrand(
      {required String id, required String key, required dynamic value}) async {
    changeLoading();
    final result =
        await UserSheetsApi.updateBrand(id: id, key: key, value: value);
    if (result) {
      await getAllBrands();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }

  Future<bool> deleteBrand({required String id}) async {
    changeLoading();

    final result = await UserSheetsApi.deleteBrand(id);
    if (result) {
      await getAllBrands();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }
}
