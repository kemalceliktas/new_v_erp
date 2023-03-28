// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../errorMesages/error_messages.dart';
import '../../models/user.dart';
import '../../pages/mainPage/main_page.dart';
import '../../service/user_sheet_api.dart';

class ProviderOne extends ChangeNotifier {
  final formGlobalKey = GlobalKey<FormState>();
  int bottomIndex = 0;
  User userProfile = User(
    name: "name",
    email: "email",
    isAdmin: false,
    password: "password",
  );
  bool isLogin = false;
  bool isFinish = false;
  void changeBottomIndex(int index) {
    bottomIndex = index;
    notifyListeners();
  }

  SharedPreferences prefs;
  bool isLoading = false;

  User loginUserMain = User(
    name: "name",
    email: "email",
    isAdmin: false,
    password: "password",
  );

  ProviderOne({required this.prefs});
  void changeIsFinish() {
    isFinish = !isFinish;

    notifyListeners();
  }

  void changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void loginUser(
      {required String name,
      required String password,
      required BuildContext context}) async {
    final isOkey = await UserSheetsApi.getUser(name, password);

    if (isOkey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        Messages().error(
            context: context,
            duration: const Duration(seconds: 3),
            message: "Bilgiler hatalı"),
      );
      return;
    } else if (isOkey.name == name && isOkey.password == password) {
      loginUserMain = isOkey;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
      prefs.setString("id", isOkey.id.toString());
      prefs.setString("isLogin", "true");
      prefs.setString("name", isOkey.name.toString());
      prefs.setString("password", isOkey.password.toString());
      prefs.setString("email", isOkey.email.toString());

      isLogin = true;
      notifyListeners();
    }
    notifyListeners();
  }

  void userProfileGet(String id, BuildContext context) async {
    final isOkey = await UserSheetsApi.getUserProfile(id);

    if (isOkey == null && prefs.getString("isLogin") != "true") {
      ScaffoldMessenger.of(context).showSnackBar(
    
        Messages().error(
            context: context,
            duration: const Duration(seconds: 3),
            message: "User bulunamadı"),
      );
      return;
    } else {
      userProfile = isOkey!;
      notifyListeners();
    }
    notifyListeners();
  }

  void registerUser({required User user, required BuildContext context}) async {
    try {
      await UserSheetsApi.insertUsers([user]);

      changeLoading();
      prefs.setString("id", user.id.toString());
      prefs.setString("isLogin", "true");
      prefs.setString("name", user.name.toString());
      prefs.setString("password", user.password.toString());
      prefs.setString("email", user.email.toString());
      loginUserMain = user;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
      notifyListeners();
      prefs.setString("isLogin", "true");
    } catch (e) {
      inspect(e.toString());
    }
  }

  void updateName({required dynamic value, required String key}) async {
    changeLoading();
    await UserSheetsApi.updateUserData(
      id: prefs.getString("id").toString(),
      key: key,
      value: value,
    );
    loginUserMain.name = value;
    changeLoading();
    notifyListeners();
  }
}
