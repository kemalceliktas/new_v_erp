import 'dart:developer';
import 'package:erp_project/models/categoryModel/category_model.dart';
import 'package:flutter/material.dart';

import '../../service/user_sheet_api.dart';

class CategoryProvider extends ChangeNotifier {
  final formGlobalKey = GlobalKey<FormState>();
  CategoryModel? categoryModel;
  List<CategoryModel?> categoryList = [];
  bool isLoading = false;

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<CategoryModel?>>? getAllCategorys() async {
    try {
      final categorys = await UserSheetsApi.getAllCategory();

      if (categorys.isEmpty) {
        notifyListeners();

        return [];
      } else {
        categoryList = categorys;

        notifyListeners();

        return categoryList;
      }
    } catch (e) {
      inspect(e.toString());
      notifyListeners();

      return [];
    }
  }

  Future<bool> addCategory(
      {required CategoryModel categoryModel,
      required BuildContext context}) async {
    changeLoading();
    categoryModel = categoryModel;

    final test = await UserSheetsApi.insertCategoryToDataBase([categoryModel])
        .then((value) async {
      return value;
    });
    if (test) {
      await getAllCategorys();
      notifyListeners();
      changeLoading();
      return true;
    }
    changeLoading();
    return false;
  }

  Future<bool> updateCategory(
      {required String id, required String key, required dynamic value}) async {
    changeLoading();
    final result =
        await UserSheetsApi.updateCategoryApi(id: id, key: key, value: value);

    if (result) {
      await getAllCategorys();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }
}
