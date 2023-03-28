import 'package:erp_project/providers/orderdetailprovider/order_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cariModel/cari_model.dart';
import '../../navigationmanager/navigation_manager.dart';
import '../../providers/orderProvider/order_provider.dart';
import '../../static/static_class.dart';
import '../ordersPage/order_detail_page.dart';

class CariDetailPage extends StatefulWidget {
  const CariDetailPage({super.key, required this.item});
  final CariModel item;
  @override
  State<CariDetailPage> createState() => _CariDetailPageState();
}

class _CariDetailPageState extends State<CariDetailPage> with NavigatorManager {
  @override
  Widget build(BuildContext context) {
    print(context
            .watch<OrderDetailProvider>()
            .orderDetailList
            .map((e) => e.where((element) => element.cari == widget.item.id))
            .toList()
            .toString() ==
        "[()]");
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.item.name} ${widget.item.lastName}"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text("+90 ${widget.item.phone} - ${widget.item.email}"),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("T.C No: ${widget.item.identificationNumber}"),
                  Text("V.No: ${widget.item.taxNumber}"),
                  Text("Adres: ${widget.item.address}"),
                ],
              ),
            ),
          ),
          context
                      .watch<OrderDetailProvider>()
                      .orderDetailList
                      .map((e) =>
                          e.where((element) => element.cari == widget.item.id))
                      .toList()
                      .toString() ==
                  "[()]"
              ? Expanded(
                  child: Center(
                    child: Text(
                      "Cariye Tanımlı Sipariş Bulunamadı",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 20),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: context
                          .watch<OrderDetailProvider>()
                          .orderDetailList
                          .map((e) => e.where(
                              (element) => element.cari == widget.item.id))
                          .toList()
                        .length,
                    itemBuilder: (context, index) {
                      final itemLast = context
                          .watch<OrderDetailProvider>()
                          .orderDetailList
                          .map((e) => e.where(
                              (element) => element.cari == widget.item.id))
                          .toList()[index];
                      final provider =
                          context.watch<OrderDetailProvider>().orderDetailList;
                      return InkWell(
                        onTap: () {
                          provider[index].isNotEmpty
                              ? navigateToWidgetReplacment(
                                  context,
                                  OrderDetailPage(
                                    cariModel: widget.item,
                                    ordeRModel: context
                              .read<OrderProvider>()
                              .orderList
                              .firstWhere((element) =>
                                  element!.orderId ==
                                  provider[index].first.orderId)!,
                                    list: provider[index],
                                  ))
                              : null;
                        },
                        child: ListTile(
                          title: Text(
                              "SP-${itemLast.first.orderId.toString().substring(0,8)}"),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Toplam"),
                              provider[index][0].prices.toString() != "[]"
                                  ? Text(StaticConst().priceFormat(
                                      context
                                          .read<OrderDetailProvider>()
                                          .calculateTotal(provider[index], "")
                                          .toString(),
                                    ))
                                  : SizedBox(),

                              //Text(parseStringToList(provider[index]!.prices.toString())[0].replaceAll("[", "").replaceAll("]", "")),

                              //priceFormat
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
