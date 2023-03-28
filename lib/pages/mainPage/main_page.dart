// ignore_for_file: deprecated_member_use

import 'package:erp_project/hive/HivetestModel/order_model.dart';
import 'package:erp_project/pages/brandPage/brand_page.dart';
import 'package:erp_project/pages/cariPage/cari_page.dart';
import 'package:erp_project/pages/ordersPage/orders_page.dart';
import 'package:erp_project/providers/orderProvider/order_provider.dart';
import 'package:erp_project/static/main_colors.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../hive/HivetestModel/homepage.dart';
import '../../navigationmanager/navigation_manager.dart';
import '../../providers/hiveprovider/hive_provider.dart';
import '../../providers/provider1/provider_one.dart';
import '../../static/static_class.dart';
import '../categoryPage/category_page.dart';
import '../loginpage/login_page.dart';
import '../productpage/product_page.dart';
import '../profilePage/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with NavigatorManager {
  @override
  void initState() {
    super.initState();

    context.read<OrderProvider>().getAllOrder();
    context.read<HiveProvider>().getItems();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProviderOne>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          drawer: Drawer(
            backgroundColor: MainColors.notionBackgroundColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                         
                          ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                             
                              context
                                  .read<ProviderOne>()
                                  .prefs
                                  .getString("name")
                                  .toString()),
                          Text(
                             
                              context
                                  .read<ProviderOne>()
                                  .prefs
                                  .getString("email")
                                  .toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Ürünler'),
                    onTap: () {
                      navigateToWidget(context, const ProductPage());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text('Kategoriler'),
                    onTap: () {
                      navigateToWidget(context, const CategoryPage());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: const Icon(Icons.receipt),
                    title: const Text('Siparişler'),
                    onTap: () {
                      navigateToWidget(context, const OrdersPageView());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: const Icon(Icons.contact_mail),
                    title: const Text('İletişim'),
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('İletişim Bilgileri'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: Text(StaticConst().phoneNumber),
                                onTap: () =>
                                    launch('tel:${StaticConst().phoneNumber}'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.email),
                                title: Text(StaticConst().emailAddress),
                                onTap: () => launch(
                                    'mailto:${StaticConst().emailAddress}'),
                              ),
                              ListTile(
                                leading: Image.asset(
                                  'assets/whatsapp.png',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                title: const Text('WhatsApp'),
                                onTap: () => launch(
                                    'https://wa.me/?text=${Uri.encodeFull(StaticConst().whatsappMessage)}'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Kapat'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const MyBottomNavigationBar(),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("ANA SAYFA"),
           
            actions: [
              IconButton(
                onPressed: () {
                  StaticConst().returnDialog(
                      message: "Çıkış yapmak istediğinize emin misiniz?",
                      context: context,
                      acceptFunc: () {
                        provider.prefs.clear();

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.logout_outlined),
              ),
            ],
          ),
          body: const AnaEkran()),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar>
    with NavigatorManager {
  int? currentIndex;

  @override
  void initState() {
    super.initState();
  }

  void _onTabTapped(int index) {
    if (context.read<ProviderOne>().bottomIndex == index) {
      return;
    }
    context.read<ProviderOne>().changeBottomIndex(index);

    switch (context.read<ProviderOne>().bottomIndex) {
      case 0:
        return navigateToWidget(context, const MainPage());
      case 1:
        return navigateToWidget(context, const HomePage2());
      case 2:
        return navigateToWidget(context, const OrdersPageView());
      case 3:
        return navigateToWidget(context, const ProfilePage());
      default:
        return navigateToWidget(context, const MainPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 22,
      unselectedFontSize: 22,
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: context.watch<ProviderOne>().bottomIndex,
      onTap: _onTabTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> with NavigatorManager {
  @override
  void initState() {
    super.initState();
    context.read<HiveProvider>().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBlock(
                  fun: () {
                    navigateToWidget(context, const CariPage());
                  },
                  icon: Icons.account_balance,
                  title: 'Cariler',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                _buildBlock(
                  fun: () {
                    navigateToWidget(context, const CategoryPage());
                  },
                  icon: Icons.category_outlined,
                  title: 'Kategoriler',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBlock(
                  fun: () {
                    navigateToWidget(context, const ProductPage());
                  },
                  icon: Icons.article,
                  title: 'Ürünler',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                _buildBlock(
                  fun: () {
                    navigateToWidget(context, const BrandPage());
                  },
                  icon: Icons.branding_watermark,
                  title: 'Markalar',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SepetWidget(
                  icon: Icons.shopping_cart,
                  title: 'Sepet',
                  fun: () {
                    navigateToWidget(context, const HomePage2());
                  },
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                OrdersWidget(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Siparişler',
                    fun: () {
                      navigateToWidget(context, const OrdersPageView());
                    },
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3),
                /* _buildBlock(
                  fun: () {
                   
                  },
                  icon: Icons.shopping_bag_outlined,
                  title: 'Siparişler',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.3,
                ), */
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildBlock({
    required IconData icon,
    required String title,
    required double width,
    required double height,
    required Function fun,
  }) {
    return InkWell(
      onTap: () => fun(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* 

 DataModel item = context
                            .watch<HiveProvider>()
                            .items
                            .cast<DataModel>()
                            .toList() */

class SepetWidget extends StatefulWidget {
  const SepetWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.fun,
    required this.width,
    required this.height,
  });
  final IconData icon;
  final String title;
  final Function fun;
  final double width;
  final double height;

  @override
  State<SepetWidget> createState() => _SepetWidgetState();
}

class _SepetWidgetState extends State<SepetWidget> {
  @override
  void initState() {
    super.initState();
    context.read<HiveProvider>().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.fun(),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(children: [
              Icon(
                widget.icon,
                size: 48.0,
                color: Colors.grey.shade600,
              ),
              Positioned(
                top: 0,
                left: 22,
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 13,
                  child: Text(context
                      .watch<HiveProvider>()
                      .items
                      .cast<OrderFinishModel>()
                      .toList()
                      .length
                      .toString()),
                ),
              ),
            ]),
            const SizedBox(height: 16.0),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.fun,
    required this.width,
    required this.height,
  });
  final IconData icon;
  final String title;
  final Function fun;
  final double width;
  final double height;

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  void initState() {
    super.initState();
    context.read<HiveProvider>().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.fun(),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(children: [
              Icon(
                widget.icon,
                size: 48.0,
                color: Colors.grey.shade600,
              ),
              /*  Positioned(
                top: 0,
                left: 22,
                child: CircleAvatar(
                  backgroundColor: Colors.green[800],
                  radius: 13,
                  child: Text(context
                      .watch<OrderDetailProvider>()
                      .orderDetailList
                      .length
                      .toString()),
                ),
              ), */
            ]),
            const SizedBox(height: 16.0),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
