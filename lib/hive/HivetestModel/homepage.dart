import 'package:erp_project/hive/HivetestModel/order_model.dart';
import 'package:erp_project/models/orderDetailModel/order_detail_model.dart';
import 'package:erp_project/models/orderModel/order_model.dart';
import 'package:erp_project/providers/cariProvider/cari_provider.dart';
import 'package:erp_project/providers/orderProvider/order_provider.dart';
import 'package:erp_project/providers/orderdetailprovider/order_detail_provider.dart';
import 'package:erp_project/service/user_sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../pages/mainPage/main_page.dart';
import '../../providers/hiveprovider/hive_provider.dart';
import '../../providers/provider1/provider_one.dart';
import '../../static/static_class.dart';
import 'data_model.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> with TickerProviderStateMixin {
  //textfield controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  //form key
  final List metrics = ["kitap", "defter", "kalem"];
  var selectedValue;
  FocusNode _firstTextFieldFocusNode = FocusNode();
  FocusNode _secondTextFieldFocusNode = FocusNode();
  FocusNode _thirdTextFieldFocusNode = FocusNode();
  FocusNode _fourTextFieldFocusNode = FocusNode();
  FocusNode _fiveTextFieldFocusNode = FocusNode();
  String _selectedType = "1"; // Varsayılan olarak "1" seçili

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> types) {
    List<DropdownMenuItem<String>> items = [];
    for (String type in types) {
      String name = getTypeName(type);
      items.add(
        DropdownMenuItem(
          value: type,
          child: Text(name),
        ),
      );
    }
    return items;
  }

  List<String> paymentType = ["1", "2", "3"];

  String getTypeName(String type) {
    switch (type) {
      case "1":
        return "Nakit";
      case "2":
        return "Kredi Kartı";
      case "3":
        return "Çek";
      default:
        return "";
    }
  }

  List<DropdownMenuItem<String>>? _dropDownMenuItems;
  @override
  void dispose() {
    _firstTextFieldFocusNode.dispose();
    _secondTextFieldFocusNode.dispose();
    _thirdTextFieldFocusNode.dispose();
    _fourTextFieldFocusNode.dispose();
    _fiveTextFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _dropDownMenuItems = buildDropdownMenuItems(paymentType);
    super.initState();

    context.read<HiveProvider>().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ProviderOne>().changeBottomIndex(0);
        return true;
      },
      child: Scaffold(
        bottomNavigationBar: const MyBottomNavigationBar(),
        appBar: AppBar(title: const Text("Sepet")),
        body: context.watch<HiveProvider>().items.isEmpty
            ? const Center(
                child: Text("Kayıt Yok"),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context
                          .watch<HiveProvider>()
                          .items
                          .cast<OrderFinishModel>()
                          .toList()
                          .length,
                      itemBuilder: (_, index) {
                        /* print(context.watch<HiveProvider>().selectedValue); */

                        OrderFinishModel item = context
                            .watch<HiveProvider>()
                            .items
                            .cast<OrderFinishModel>()
                            .toList()[index];

                        return Card(
                          margin: const EdgeInsets.all(20),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: Text("${item.adet} - ${item.barcode}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${item.price?.toCurrency()}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //edit icon

                                // Delete button
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      StaticConst().returnDialog(
                                          message:
                                              "Notu silmek istediğinizden emin misiniz?",
                                          context: context,
                                          acceptFunc: () {
                                            context
                                                .read<HiveProvider>()
                                                .deleteItem(
                                                  context
                                                      .read<HiveProvider>()
                                                      .box,
                                                  context
                                                      .read<HiveProvider>()
                                                      .items[index],
                                                );
                                            context
                                                .read<HiveProvider>()
                                                .calculateTotal();

                                            Navigator.of(context).pop();
                                          });

                                      /* box = await Hive.openBox('hive_box');
                                            box.delete(context.watch<HiveProvider>().items[index].key);
                                            context.read<HiveProvider>().getItems(); */
                                    }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sipariş Toplam : ",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            StaticConst()
                                .priceFormat(context
                                    .watch<HiveProvider>()
                                    .total
                                    .toString())
                                .toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          //StaticConst().priceFormat(context.watch<HiveProvider>().total.toString()).toString())
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showPaymentDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(child: Text('SİPARİŞİ TAMAMLA')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void showPaymentDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cari ve Ödeme Tipi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                hint: const Text("Ödeme Tipi"),
                value: _selectedType,
                items: _dropDownMenuItems,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value.toString();
                  });
                  print(_selectedType.toString() + "SELECTED TYPE");
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                hint: const Text("Cari"),
                value: selectedValue,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue;
                    print(selectedValue.toString());
                  });
                },
                items: context.watch<CariProvider>().cariList.isEmpty
                    ? null
                    : context
                        .watch<CariProvider>()
                        .cariList
                        .map((metric) => DropdownMenuItem<String>(
                              value: metric!.id,
                              child: Text(metric.name.toString()),
                            ))
                        .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                setState(() {
                  amountController.clear();

                 
                });
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Ödeme Ekle'),
              ),
              onPressed: () {
              
              
                  // Butona tıklandığında yapılacak işlemler
                  String id = const Uuid().v4();
                  List<OrderDetailModel> convertDataToTestModels(
                      List<OrderFinishModel> data) {
                    List<OrderDetailModel> testModels = [];

                    for (int i = 0; i < data.length; i++) {
                      OrderFinishModel item = data[i];

                      OrderDetailModel testModel = OrderDetailModel(
                        type: _selectedType.toString(),
                        orderId: id.toString(),
                        barcodes: item.barcode,
                        prices: item.price,
                        quantity: item.adet,
                        ispaid: false.toString(),
                        brands: item.brand,
                        categorys: item.kategori,
                        cari: selectedValue.toString(),
                        date: DateTime.now().toString(),
                        isArchive: false.toString(),
                        status: "1",
                      );

                      testModels.add(testModel);
                    }

                    return testModels;
                  }

                  final order = OrdeRModel(
                    status: "1",
                    orderId: id.toString(),
                    barcodes: context
                        .read<HiveProvider>()
                        .items
                        .cast<OrderFinishModel>()
                        .toList()
                        .map((e) => e.barcode)
                        .toList()
                        .toString(),
                    prices: context
                        .read<HiveProvider>()
                        .items
                        .cast<OrderFinishModel>()
                        .toList()
                        .map((e) =>
                            e.price!.replaceAll(".", "").replaceAll(",", "."))
                        .toList()
                        .toString(),
                    quantity: "quantity",
                    ispaid: "0.0",
                    brands: "brands",
                    categorys: "categorys",
                    cari: selectedValue.toString(),
                    date: DateTime.now().toString(),
                    isArchive: "1",
                    paymentType: "",
                  );
                 
                  context.read<OrderDetailProvider>().addOrderDetail(
                      orderModel: convertDataToTestModels(context
                          .read<HiveProvider>()
                          .items
                          .cast<OrderFinishModel>()
                          .toList()),
                      context: context);
                  context
                      .read<OrderProvider>()
                      .addOrder(context: context, ordeRModel: order);
                  context.read<OrderDetailProvider>().createOrderDetail(convertDataToTestModels(context
                          .read<HiveProvider>()
                          .items
                          .cast<OrderFinishModel>()
                          .toList()), order);
                  context.read<HiveProvider>().clearHive();
                  context.read<OrderProvider>().getAllOrder();
                  setState(() {
                    amountController.clear();
                  });
             
                // Ödeme türü ve miktar bilgileri kullanılabilir
                context.read<OrderDetailProvider>().getAllOrderDetails();
                context.read<OrderDetailProvider>().getAllOrder();
                context.read<OrderProvider>().getAllOrder();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



 