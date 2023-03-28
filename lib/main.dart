import 'dart:io';
import 'package:erp_project/pages/splashPage/splash_page.dart';
import 'package:erp_project/providers/brandProvider/brand_provider.dart';
import 'package:erp_project/providers/cariProvider/cari_provider.dart';
import 'package:erp_project/providers/categoryProvider/category_provider.dart';
import 'package:erp_project/providers/hiveprovider/hive_provider.dart';
import 'package:erp_project/providers/orderProvider/order_provider.dart';
import 'package:erp_project/providers/orderdetailprovider/order_detail_provider.dart';
import 'package:erp_project/providers/productProvider/product_provider.dart';
import 'package:erp_project/providers/provider1/provider_one.dart';
import 'package:erp_project/service/user_sheet_api.dart';
import 'package:erp_project/static/main_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'hive/HivetestModel/order_model.dart';

Future<String?> readData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? data = prefs.getString("isLogin");
  return data;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  final prefs = await SharedPreferences.getInstance();
  await UserSheetsApi.init();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(OrderFinishModelAdapter());
  await Hive.openBox("order_box");
  String? data = await readData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderOne>(
          create: (_) => ProviderOne(prefs: prefs),
        ),
        ChangeNotifierProvider<HiveProvider>(
          create: (_) => HiveProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<BrandProvider>(
          create: (_) => BrandProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider<CariProvider>(
          create: (_) => CariProvider(),
        ),
        ChangeNotifierProvider<OrderDetailProvider>(
          create: (_) => OrderDetailProvider(),
        ),
      ],
      child: MyApp(
        data: data ?? "",
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: MainTheme.notionThemeData,
      home: SplashScreen(data: data),
    );
  }
}
