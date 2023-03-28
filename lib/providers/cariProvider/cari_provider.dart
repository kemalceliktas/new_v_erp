import 'package:erp_project/models/cariModel/cari_model.dart';
import 'package:flutter/material.dart';

import '../../service/user_sheet_api.dart';

class CariProvider extends ChangeNotifier {
  final formGlobalKey = GlobalKey<FormState>();
  CariModel? cariModel;
  List<CariModel?> cariList = [];
  bool isLoading = false;

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<List<CariModel?>>? getAllCariler() async {
    
    try {
      final cari = await UserSheetsApi.getAllCari();

      if (cari.isEmpty) {
        notifyListeners();
   
        return [];
      } else {
        cariList = cari;

        notifyListeners();
       
        return cariList;
      }
    } catch (e) {
      print(e.toString());
      notifyListeners();
     
      return [];
    }
  }

  Future<bool> addCari(
      {required CariModel cariModl, required BuildContext context}) async {
    changeLoading();
    cariModel = cariModl;
    cariList.add(cariModl);
    print("WORK");
    final test = await UserSheetsApi.insertCariToDataBase([cariModl])
        .then((value) async {
      return value;
    });
    if (test) {
      await getAllCariler();
      notifyListeners();
      changeLoading();
      return true;
    }
    changeLoading();
    return false;
  }

  Future<bool> updateCari(
      {required String id, required String key, required dynamic value}) async {
    changeLoading();
    final result =
        await UserSheetsApi.updateCari(id: id, key: key, value: value);
   
    if (result) {
      await getAllCariler();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }

  Future<bool> deleteCari({required String id})async{
    changeLoading();

    final result=await UserSheetsApi.deleteCari(id);
    if (result) {

      await getAllCariler();
      notifyListeners();
      changeLoading();
      return true;
    }
    notifyListeners();
    changeLoading();
    return false;
  }
}
