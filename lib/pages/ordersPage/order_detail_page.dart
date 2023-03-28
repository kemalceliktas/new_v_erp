import 'package:erp_project/main.dart';
import 'package:erp_project/models/cariModel/cari_model.dart';
import 'package:erp_project/models/orderDetailModel/order_detail_model.dart';
import 'package:erp_project/providers/orderProvider/order_provider.dart';
import 'package:erp_project/static/static_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/orderModel/order_model.dart';
import '../../providers/cariProvider/cari_provider.dart';
import '../../providers/orderdetailprovider/order_detail_provider.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../static/main_colors.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(
      {super.key, required this.list, required this.ordeRModel,required this.cariModel});
  final List<OrderDetailModel> list;
  final OrdeRModel ordeRModel;
  final CariModel cariModel;
  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final TextEditingController amountController = TextEditingController();
  String? selectedValue;
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
  void initState() {
    _dropDownMenuItems = buildDropdownMenuItems(paymentType);
    _getData();
    
    super.initState();
  }

  void _getData() {
    context
        .read<OrderDetailProvider>()
        .createOrderDetail(widget.list, widget.ordeRModel);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderDetailProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                // await printDocumentT(widget.list as List<Map<String,dynamic>>);
                await printDocument(
                    list: widget.list, ordeRModel: widget.ordeRModel,cari: widget.cariModel,total: provider.total.toString());
              },
              icon: Icon(Icons.print_outlined),)
        ],
        title: Text("SİPARİŞ DETAY"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Card(
              child: ListTile(
                title: Text(
                    "ARA TOPLAM : ${StaticConst().priceFormat(provider.orderTotal.toString())}"),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: MainColors.notionIconColor),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("YAPILAN ÖDEME"),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showPaymentDialog(context);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                ),
                Text(
                  StaticConst().priceFormat(
                    context
                        .watch<OrderDetailProvider>()
                        .orderPayment
                        .toString(),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              child: ListTile(
                title: Text(
                    "SİPARİŞ TOPLAM : ${StaticConst().priceFormat(provider.orderNewTotal.toString())}"),
                    subtitle: Text("CARİ : ${widget.cariModel.name}"),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
                onPressed: () {
                  showCloseOrder(context);
                },
                child: Center(
                  child: Text("SİPARİŞİ TAMAMLA"),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "SİPARİŞ ÜRÜNLER",
                  style: Theme.of(context).textTheme.titleMedium,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Colors.black,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    child: ListTile(
                      title: Text(widget.list[index].brands.toString()),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("${widget.list[index].barcodes}  "),
                              Text(
                                  "${StaticConst().priceFormat(widget.list[index].prices.toString())} x${widget.list[index].quantity} adet"),
                            ],
                          ),
                        ],
                      ),
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

  void showCloseOrder(BuildContext context) {
    var cariValue;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ödeme Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Siparişinizin süreci tamamlandıya alınıp kapatılacaktır. Onaylıyor musunuz ?"),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                hint: const Text("Cari"),
                value: cariValue,
                onChanged: (newValue) {
                  setState(() {
                    cariValue = newValue;
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
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Onaylıyorum'),
              ),
              onPressed: () {
                print(widget.list.first.orderId);
                print(cariValue.toString());
                // Ödeme ekleme işlemleri burada yapılacak
                context.read<OrderProvider>().updatePayment(
                    id: widget.list.first.orderId!,
                    key: "cari",
                    value: cariValue);
                context.read<OrderProvider>().updatePayment(
                    id: widget.list.first.orderId!, key: "status", value: "2");
                context.read<OrderDetailProvider>().updateOrderDetails(
                    id: widget.list.first.orderId!, key: "status", value: "2");
                context.read<OrderDetailProvider>().updateOrderDetails(
                    id: widget.list.first.orderId!,
                    key: "cari",
                    value: cariValue);
                context.read<OrderProvider>().updatePayment(
                    id: widget.list.first.orderId!,
                    key: "isPaid",
                    value: context
                        .read<OrderDetailProvider>()
                        .orderTotal
                        .toString());
                context.read<OrderProvider>().getAllOrder();

                // Ödeme türü ve miktar bilgileri kullanılabilir
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Siparişi Tamamla'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Miktar',
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                value: _selectedType,
                items: _dropDownMenuItems,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value.toString();
                  });
                  print(_selectedType.toString() + "SELECTED TYPE");
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                amountController.clear();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Ödeme Ekle'),
              ),
              onPressed: () {
                // Ödeme ekleme işlemleri burada yapılacak
                String amountText = amountController.text;
                double amount = double.tryParse(amountText) ?? 0.0;
                context
                      .read<OrderDetailProvider>()
                      .addPayment(amount.toString());
                if (amount == 0.0) {
                  print("ERROR");
                  return;
                } else {
                  print(amount);
                  
                  context.read<OrderProvider>().updatePayment(
                      id: widget.list.first.orderId.toString(),
                      key: "isPaid",
                      value: context.read<OrderDetailProvider>().orderPayment);
                  context.read<OrderProvider>().updatePayment(
                      id: widget.list.first.orderId.toString(),
                      key: "paymentType",
                      value: _selectedType.toString());
                  context.read<OrderProvider>().getAllOrder();

                  setState(() {
                    amountController.clear();
                  });
                }
                // Ödeme türü ve miktar bilgileri kullanılabilir
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/* void printDocument() async {
  final pdf = pw.Document();
  
  // Ekrandaki verileri pdf belgesine ekleme
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Adisyon")),
          pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Barkod', 'Marka', 'Ürün', 'Adet'],
                <String>['123', 'Samsung', 'TV', '2'],
                <String>['456', 'Apple', 'iPhone', '1'],
              ]),
        ];
      }));

  // Pdf belgesini Uint8List'e dönüştürme
  final Uint8List pdfData = await pdf.save();
  
  // Yazıcıya gönderme işlemi
  Printing.layoutPdf(
      onLayout: (_) => pdfData.buffer.asByteData(),
      name: 'adisyon.pdf');
} */

Future<void> printDocument(
    {required List<OrderDetailModel> list,
    required OrdeRModel ordeRModel,required CariModel cari,required String total}) async {
  final pdf = pw.Document();
  print(ordeRModel.date.toString());
  // Ekrandaki verileri pdf belgesine ekleme
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        final List<pw.TableRow> rows = list.map((order) {
          return pw.TableRow(
            children: [
              pw.Text(order.barcodes.toString()),
              pw.Text(order.brands.toString()),
              pw.Text(order.categorys.toString()),
              pw.Text(order.quantity.toString()),
              pw.Text('${order.prices}₺'),
            ],
          );
        }).toList();
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Siparis Detay")),
          pw.Column(children: <pw.Widget>[
            pw.Align(
                child: pw.Text("SP-${ordeRModel.orderId!.substring(0, 8)}")),
            pw.Divider(),
          ]),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  pw.Text('Barkod'),
                  pw.Text('Marka'),
                  pw.Text('Kategori'),
                  pw.Text('Adet'),
                  pw.Text('Fiyat'),
                ],
              ),
              ...rows,
            ],
          ),
          pw.SizedBox(height: 10),
           pw.Divider(),
           pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Cari Detay",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Text("Ad-Soyad: ${cari.name} ${cari.lastName}", style: pw.TextStyle(fontSize: 12)),
                pw.Text("Telefon: ${cari.phone}", style: pw.TextStyle(fontSize: 12)),
                pw.Text("Eposta: ${cari.email}", style: pw.TextStyle(fontSize: 12)),
                pw.Text("Adres: ${cari.address}", style: pw.TextStyle(fontSize: 12)),
                pw.Text(""),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 10),
                pw.Text("Sipariş Ödeme Detay",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Sipariş Toplam:",
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text("${total}",
                          style: pw.TextStyle(fontSize: 12)),
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Sipariş Ödeme Tipi:",
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text("${StaticConst().paymentTypeString(ordeRModel.paymentType.toString())}",
                          style: pw.TextStyle(fontSize: 12)),
                    ]),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Sipariş Tarihi:",
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text("${list.first.formattedDate}",
                          style: pw.TextStyle(fontSize: 12)),
                    ]),
              ]),
          
        ];
      }));

  // Pdf belgesini Uint8List'e dönüştürme
  final Uint8List pdfData = await pdf.save();

  // Yazıcıya gönderme işlemi
  await Printing.layoutPdf(onLayout: (_) => pdfData, name: 'adisyon.pdf');
}

Future<void> printDocumentT(List<Map<String, dynamic>> orders) async {
  final pdf = pw.Document();

  // Ekrandaki verileri pdf belgesine ekleme
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        // Tablo satırlarını oluşturma
        final List<pw.TableRow> rows = orders.map((order) {
          return pw.TableRow(
            children: [
              pw.Text(order['barcodes'].toString()),
              pw.Text(order['brands']),
              pw.Text(order['categorys']),
              pw.Text(order['quantity'].toString()),
              pw.Text(order['prices'].toString() + '₺'),
            ],
          );
        }).toList();

        // Tabloyu oluşturma
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Adisyon")),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  pw.Text('Barkod'),
                  pw.Text('Marka'),
                  pw.Text('Kategori'),
                  pw.Text('Adet'),
                  pw.Text('Fiyat'),
                ],
              ),
              ...rows,
            ],
          ),
        ];
      },
    ),
  );

  // Pdf belgesini Uint8List'e dönüştürme
  final Uint8List pdfData = await pdf.save();

  // Yazıcıya gönderme işlemi
  await Printing.layoutPdf(onLayout: (_) => pdfData, name: 'adisyon.pdf');
}



/* Future<void> printDocument() async {
  final pdf = pw.Document();

  // Ekrandaki verileri pdf belgesine ekleme
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Adisyon")),
          pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Barkod', 'Marka', 'Ürün', 'Adet'],
                <String>['123', 'Samsung', 'TV', '2'],
                <String>['456', 'Apple', 'iPhone', '1'],
              ]),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 10),
          
        ];
      }));

  // Pdf belgesini Uint8List'e dönüştürme
  final Uint8List pdfData = await pdf.save();

  // Yazıcıya gönderme işlemi
  await Printing.layoutPdf(
      onLayout: (_) => pdfData.buffer.asByteData(),
      name: 'adisyon.pdf');
}
 */