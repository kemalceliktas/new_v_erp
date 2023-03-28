import 'dart:developer';

import 'package:erp_project/models/brandModel/brand_model.dart';
import 'package:erp_project/models/cariModel/cari_model.dart';
import 'package:erp_project/models/categoryModel/category_model.dart';
import 'package:erp_project/models/orderDetailModel/order_detail_model.dart';
import 'package:erp_project/models/orderModel/order_model.dart';
import 'package:erp_project/models/productModel/product_model.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserSheetsApi {
  static const _credentials = r'''
{

}
''';
  static const String _sheetId = "";

  static final GSheets _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;
  static Worksheet? _brandSheet;
  static Worksheet? _categorySheet;
  static Worksheet? _productSheet;
  static Worksheet? _ordersSheet;
  static Worksheet? _cariSheet;
  static Worksheet? _orderDetailSheet;

  SharedPreferences? prefs;
// init sheet main
  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_sheetId);
      // Obtain shared preferences.

      _userSheet = await _getWorkSheet(spreadsheet, title: "Users");
      _brandSheet = await _getWorkSheet(spreadsheet, title: "Brands");
      _categorySheet = await _getWorkSheet(spreadsheet, title: "Categories");
      _productSheet = await _getWorkSheet(spreadsheet, title: "Products");
      _ordersSheet = await _getWorkSheet(spreadsheet, title: "Orders");
      _cariSheet = await _getWorkSheet(spreadsheet, title: "Cari");
      _orderDetailSheet =
          await _getWorkSheet(spreadsheet, title: "OrderDetail");

      final firstRow = UserFields.getFields();
      final firstRowBrand = BrandFields.getFields();
      final firstRowCategory = CategoryFields.getFields();
      final firstRowProduct = ProductFields.getFields();
      final firstRowOrders = OrderFields.getFields();
      final firstRowCari = CariFields.getFields();
      final firstRowOrderDetail = OrderDetailFields.getFields();

      _userSheet!.values.insertRow(1, firstRow);
      _brandSheet!.values.insertRow(1, firstRowBrand);
      _categorySheet!.values.insertRow(1, firstRowCategory);
      _productSheet!.values.insertRow(1, firstRowProduct);
      _ordersSheet!.values.insertRow(1, firstRowOrders);
      _cariSheet!.values.insertRow(1, firstRowCari);
      _orderDetailSheet!.values.insertRow(1, firstRowOrderDetail);
    }on GSheetsException catch (e) {
      GSheetsException(e.cause);
    }
  }

  //  funk. sheet page
  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } on GSheetsException catch (e) {
      inspect(e.toString());
      return spreadsheet.worksheetByTitle(title)!;
      
    }
  }

  // add brand to database
  static Future<bool> insertBrand(List<Map<String, dynamic>> rowList) async {
    if (_brandSheet == null) return false;
    final result = await _brandSheet!.values.map.appendRows(rowList);
    if (result) {
      return true;
    }
    return false;
  }

  static Future<bool> insertBrandToDataBase(List<BrandModel> brand) async {
    final jsonBrands = brand.map((e) => e.toJson()).toList();
    try {
      final result = await UserSheetsApi.insertBrand(jsonBrands);
      if (result) {
        return true;
      }

      return false;
    } catch (e) {
      inspect(e.toString());
      return false;
    }
  }
// get brand

  static Future<List<BrandModel?>> getAllBrand() async {
    if (_brandSheet == null) {
      print("NO BRANDSHEET");
      return [];
    }

    final brands = await _brandSheet!.values.map.allRows();

    if (brands != null) {
      return brands.map((e) => BrandModel.fromJson(e)).toList();
    }
    print("error brand for get");
    return [];
  }

  // updateBrand
  static Future<bool> updateBrand(
      {required String id, required String key, required dynamic value}) async {
    if (_brandSheet == null) return false;

    return await _brandSheet!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  // delete brand

  static Future<bool> deleteBrand(String id) async {
    final index = await _brandSheet!.values.rowIndexOf(id);

    return _brandSheet!.deleteRow(index);
  }

  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

  // add cari to database
  static Future<bool> insertCari(List<Map<String, dynamic>> rowList) async {
    if (_cariSheet == null) return false;
    final result = await _cariSheet!.values.map.appendRows(rowList);
    if (result) {
      return true;
    }
    return false;
  }

  static Future<bool> insertCariToDataBase(List<CariModel> cari) async {
    final jsonBrands = cari.map((e) => e.toJson()).toList();
    try {
      final result = await UserSheetsApi.insertCari(jsonBrands);
      if (result) {
        return true;
      }

      return false;
    } catch (e) {
      inspect(e.toString());
      return false;
    }
  }
// get cari

  static Future<List<CariModel?>> getAllCari() async {
    if (_cariSheet == null) {
      return [];
    }

    final cari = await _cariSheet!.values.map.allRows();

    if (cari != null) {
      return cari.map((e) => CariModel.fromJson(e)).toList();
    }
    return [];
  }

  // update Cari
  static Future<bool> updateCari(
      {required String id, required String key, required dynamic value}) async {
    if (_cariSheet == null) return false;

    return await _cariSheet!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  // delete cari

  static Future<bool> deleteCari(String id) async {
    final index = await _cariSheet!.values.rowIndexOf(id);

    return _cariSheet!.deleteRow(index);
  }
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

  // add cari to database
  static Future<bool> insertOrderDetail(
      List<Map<String, dynamic>> rowList) async {
    if (_orderDetailSheet == null) return false;
    final result = await _orderDetailSheet!.values.map.appendRows(rowList);
    if (result) {
      return true;
    }
    return false;
  }

  static Future<bool> insertOrderDetailToDataBase(
      List<OrderDetailModel> orderDetail) async {
    final jsonBrands = orderDetail.map((e) => e.toJson()).toList();
    try {
      final result = await UserSheetsApi.insertOrderDetail(jsonBrands);
      if (result) {
        return true;
      }

      return false;
    } catch (e) {
      inspect(e.toString());
      return false;
    }
  }
// get cari

  static Future<List<OrderDetailModel?>> getAllOrderDetails() async {
    if (_orderDetailSheet == null) {
      print("NO BRANDSHEET");
      return [];
    }

    final orderDetail = await _orderDetailSheet!.values.map.allRows();

    if (orderDetail != null) {
      return orderDetail.map((e) => OrderDetailModel.fromJson(e)).toList();
    }
    print("error brand for get");
    return [];
  }

  // update Cari
  static Future<bool> updateOrderDetail(
      {required String id, required String key, required dynamic value}) async {
    if (_orderDetailSheet == null) return false;

    return await _orderDetailSheet!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  // delete cari

  static Future<bool> deleteOrderDetail(String id) async {
    final index = await _orderDetailSheet!.values.rowIndexOf(id);

    return _orderDetailSheet!.deleteRow(index);
  }
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------

  // add category to database
  static Future<bool> insertCategory(List<Map<String, dynamic>> rowList) async {
    if (_categorySheet == null) return false;
    final result = await _categorySheet!.values.map.appendRows(rowList);

    if (result) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> insertCategoryToDataBase(
      List<CategoryModel> category) async {
    final jsonCategory = category.map((e) => e.toJson()).toList();
    try {
      final result = await UserSheetsApi.insertCategory(jsonCategory);
      if (result) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      inspect(e.toString());
      return false;
    }
  }

  // get all category

  static Future<List<CategoryModel?>> getAllCategory() async {
    if (_categorySheet == null) {
      print("NO Category");
      return [];
    }

    final categorys = await _categorySheet!.values.map.allRows();

    if (categorys != null) {
      return categorys.map((e) => CategoryModel.fromJson(e)).toList();
    }
    print("error category for get");
    return [];
  }

  // update Category
  static Future<bool> updateCategoryApi(
      {required String id, required String key, required dynamic value}) async {
    if (_categorySheet == null) return false;

    return await _categorySheet!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  // delete category

  static Future<bool> deleteCategoryApi(String id) async {
    final index = await _categorySheet!.values.rowIndexOf(id);

    return _categorySheet!.deleteRow(index);
  }

  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
  // ---------------------------------------------------
  // add order to database
  static Future insertOrder(List<Map<String, dynamic>> rowList) async {
    if (_ordersSheet == null) return;
    _ordersSheet!.values.map.appendRows(rowList);
  }

  static Future<bool> insertOrderToDatabase(List<OrdeRModel> orders) async {
    final jsonOrders = orders.map((e) => e.toJson()).toList();
    try {
      await UserSheetsApi.insertOrder(jsonOrders);
      print(jsonOrders.toString());
      return true;
    } catch (e) {
      inspect(e.toString());
      return false;
    }
  }

  // update Ödeme
  static Future<bool> updatePayment(
      {required String id, required String key, required dynamic value}) async {
    if (_ordersSheet == null) return false;

    return await _ordersSheet!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  // add product to database
  static Future insertProduct(List<Map<String, dynamic>> rowList) async {
    if (_productSheet == null) return;
    _productSheet!.values.map.appendRows(rowList);
  }

  static Future<bool> insertProductToDataBase(
      List<ProductModel> product) async {
    final jsonProduct = product.map((e) => e.toJson()).toList();
    try {
      await UserSheetsApi.insertProduct(jsonProduct);
      await getAllProduct();
      return true;
    } catch (e) {
      inspect(e.toString());
      return false;
    }
  }

  //get all products

  static Future<List<ProductModel?>> getAllProduct() async {
    if (_ordersSheet == null) return [];

    final orders = await _productSheet!.values.map.allRows();
    if (orders != null) {
      return orders.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }

  // delete product
  static Future<bool> deleteProduct(String id) async {
    final index = await _productSheet!.values.rowIndexOf(id);

    return _productSheet!.deleteRow(index);
  }


  // get all Orders

  static Future<List<OrdeRModel?>> getAllOrders() async {
    if (_ordersSheet == null) return [];

    final orders = await _ordersSheet!.values.map.allRows();
    if (orders != null) {
      return orders.map((e) => OrdeRModel.fromJson(e)).toList();
    }
    return [];
  }

  // add user to database
  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;
    _userSheet!.values.map.appendRows(rowList);
  }

  static Future<bool> insertUsers(List<User> users) async {
    final jsonUsers = users.map((e) => e.toJson()).toList();
    try {
      await UserSheetsApi.insert(jsonUsers);

      return true;
    } catch (e) {
      inspect(e.toString());
      return false;
    }
  }

//login
  static Future<User?> getUser(String name, String password) async {
    if (_userSheet == null) return null;

    final users = await _userSheet!.values.map.allRows();

    if (users != null) {
      if (users
          .where((element) =>
              element["name"] == name && element["password"] == password)
          .isNotEmpty) {
        final user = users.where((element) =>
            element["name"] == name && element["password"] == password);
        return User(
            id: user.first["id"],
            name: name,
            email: user.first["email"],
            isAdmin: false,
            password: password);
      }
    }
    return null;
  }

  static Future<User?> getUserProfile(String id) async {
    if (_userSheet == null) return null;

    final users = await _userSheet!.values.map.allRows();

    if (users != null) {
      if (users.where((element) => element["id"] == id).isNotEmpty) {
        final user = users.where((element) => element["id"] == id);

        return User(
            id: user.first["id"],
            name: user.first["name"],
            email: user.first["email"],
            isAdmin: false,
            password: user.first["password"]);
      }
    }
    return null;
  }

  static Future<bool> updateNote(
      {required String id, required String key, required dynamic value}) async {
    if (_brandSheet == null) return false;

    return await _brandSheet!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

// updateData
  static Future<bool> updateUserData(
      {required String id, required String key, required dynamic value}) async {
    if (_userSheet == null) return false;

    return await _userSheet!.values
        .insertValueByKeys(value, columnKey: key, rowKey: id);
  }

  //_________________________________

  static Future<void> deleteRowsWithId(String id) async {
    final allRows = await _orderDetailSheet!.values.allRows();
    final rowsToDelete = allRows.where((row) => row[0] == id).toList();
    for (final row in rowsToDelete) {
      final index = await _orderDetailSheet!.values.rowIndexOf(row);
      await _orderDetailSheet!.deleteRow(index);
    }
  }
}

extension on String {
  bool toBoolean() {
    return (this.toLowerCase() == "true" || this.toLowerCase() == "1")
        ? true
        : (this.toLowerCase() == "false" || this.toLowerCase() == "0"
            ? false
            : false);
  }
}
