import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigationmanager/navigation_manager.dart';
import '../../providers/brandProvider/brand_provider.dart';
import '../../providers/cariProvider/cari_provider.dart';
import '../../providers/categoryProvider/category_provider.dart';
import '../../providers/orderProvider/order_provider.dart';
import '../../providers/orderdetailprovider/order_detail_provider.dart';
import '../../providers/productProvider/product_provider.dart';
import '../mainPage/main_page.dart';
import '../signuppage/sign_up_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.data});
  final String data;
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, NavigatorManager {
  late final AnimationController _controller;
  bool isLoading = false;

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void getDate() {
    changeLoading();
    context.read<OrderDetailProvider>().getAllOrderDetails();
    context.read<OrderDetailProvider>().getAllOrder();
    context.read<OrderProvider>().getAllOrder();
    context.read<CategoryProvider>().getAllCategorys();
    context.read<ProductProvider>().getAllProduct();
    context.read<BrandProvider>().getAllBrands();
    context.read<CariProvider>().getAllCariler();
    changeLoading();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), getDate);
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    Future.delayed(const Duration(seconds: 3), () {
      navigateToWidget(
          context, widget.data == "true" ? const MainPage() : const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(_controller),
          child: const Icon(
            Icons.pages,
            size: 100.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
