import 'package:erp_project/navigationmanager/navigation_manager.dart';
import 'package:erp_project/providers/cariProvider/cari_provider.dart';
import 'package:erp_project/providers/orderProvider/order_provider.dart';
import 'package:erp_project/providers/orderdetailprovider/order_detail_provider.dart';
import 'package:erp_project/static/static_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../static/main_colors.dart';
import 'order_detail_page.dart';

class OngoingOrders extends StatefulWidget {
  const OngoingOrders({super.key, required this.paramater});
  final String paramater;
  @override
  State<OngoingOrders> createState() => _OngoingOrdersState();
}

class _OngoingOrdersState extends State<OngoingOrders> with NavigatorManager {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  void getDate() {
    context.read<OrderDetailProvider>().getAllOrderDetails();
    context.read<OrderDetailProvider>().getAllOrder();
    context.read<OrderProvider>().getAllOrder();
    context.read<CariProvider>().getAllCariler();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: context
                      .watch<OrderDetailProvider>()
                      .orderList
                      .where((element) => element.status == widget.paramater)
                      .isNotEmpty
              ? ListView.builder(
                  itemCount: context
                      .watch<OrderDetailProvider>()
                      .orderDetailList
                      .where(
                          (element) => element.first.status == widget.paramater)
                      .length,
                  itemBuilder: (context, index) {
                    final provider = context
                        .watch<OrderDetailProvider>()
                        .orderDetailList
                        .where((element) =>
                            element.first.status == widget.paramater)
                        .toList();

                    return InkWell(
                      onTap: () {
                        provider[index].isNotEmpty
                            ? navigateToWidget(
                                context,
                                OrderDetailPage(
                                  cariModel: context.read<CariProvider>().cariList.where((element) => element!.id==provider[index].first.cari).first!,
                                  list: provider[index],
                                  ordeRModel: context
                                      .read<OrderProvider>()
                                      .orderList
                                      .firstWhere((element) =>
                                          element!.orderId ==
                                          provider[index].first.orderId)!,
                                ))
                            : null;
                      },
                      child: Card(
                        child: ListTile(
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider[index][0].formattedDate.toString()),
                            ],
                          ),
                          title: Text(
                              "SP-${provider[index][0].orderId.toString().substring(0, 8)}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Toplam"),
                              provider[index][0].prices.toString() != "[]"
                                  ? Text(StaticConst().priceFormat(
                                      context
                                          .read<OrderDetailProvider>()
                                          .calculateTotal(provider[index], context.watch<OrderProvider>().orderList.firstWhere((element) => element!.orderId==provider[index].first.orderId)!.ispaid.toString())
                                          .toString(),
                                    ))
                                  : SizedBox(),
                             /*  Text("Ödenen"),
                              Text(context
                                  .read<OrderProvider>()
                                  .orderList[index]!
                                  .ispaid
                                  .toString()), */
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text("Sipariş Bulunamadı"),
                ),
        )
      ],
    );
  }
}

class OrdersPageView extends StatefulWidget {
  const OrdersPageView({super.key});

  @override
  State<OrdersPageView> createState() => _OrdersPageViewState();
}

class _OrdersPageViewState extends State<OrdersPageView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
     getData();
    _tabController =
        TabController(length: _MyTabViews.values.length, vsync: this);
  }
  void changeLoading() {
    setState(() {
      isLoading=!isLoading;
    });
  }
  void getData() {
    
    context.read<OrderDetailProvider>().getAllOrderDetails();
    context.read<OrderDetailProvider>().getAllOrder();
    context.read<OrderProvider>().getAllOrder();
    Future.delayed(const Duration(seconds: 2),changeLoading);
  }
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _MyTabViews.values.length,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text("SİPARİŞLER"),
          /* bottom: TabBar(
            controller: _tabController,
            tabs: _MyTabViews.values.map((e) => Tab(text: e.name,)).toList()
          ), */
        ),
        body:isLoading ?Column(
          children: [
            TabBar(
                labelColor: MainColors.notionPrimary,
                unselectedLabelColor: MainColors.notionAccent,
                indicatorColor: MainColors.notionSecondary,
                controller: _tabController,
                tabs: _MyTabViews.values
                    .map((e) => Tab(
                          text: e.name,
                        ))
                    .toList()),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  OngoingOrders(
                    paramater: "1",
                  ),
                  OngoingOrders(
                    paramater: "2",
                  ),
                ],
              ),
            ),
          ],
        ):Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}

enum _MyTabViews { Aktif, Tamamlandi }
