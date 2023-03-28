import 'package:erp_project/models/brandModel/brand_model.dart';
import 'package:erp_project/models/categoryModel/category_model.dart';
import 'package:erp_project/models/orderModel/order_model.dart';
import 'package:erp_project/models/productModel/product_model.dart';
import 'package:erp_project/providers/brandProvider/brand_provider.dart';
import 'package:erp_project/providers/categoryProvider/category_provider.dart';
import 'package:erp_project/providers/orderProvider/order_provider.dart';
import 'package:erp_project/providers/productProvider/product_provider.dart';
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

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
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
  bool isLoadingPage = false;
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
    super.initState();

    context.read<CategoryProvider>().getAllCategorys();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ProviderOne>().changeBottomIndex(0);
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showForm(context, null, null,
                context.read<CategoryProvider>().categoryList);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
        appBar: AppBar(title: const Text("KATEGORİLER")),
        body: context.watch<CategoryProvider>().categoryList.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          context.watch<CategoryProvider>().categoryList.length,
                      itemBuilder: (_, index) {
                        final item = context
                            .watch<CategoryProvider>()
                            .categoryList[index];
                        return Card(
                          margin: const EdgeInsets.all(20),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            title: !context.watch<CategoryProvider>().isLoading
                                ? Text("${item!.name}")
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: const CircularProgressIndicator()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //edit icon
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showForm(
                                          context,
                                          "name",
                                          index,
                                          context
                                              .read<CategoryProvider>()
                                              .categoryList);
                                    }),
                                // Delete button
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      StaticConst().returnDialog(
                                        message:
                                            "Notu silmek istediğinizden emin misiniz?",
                                        context: context,
                                        acceptFunc: () {
                                          print("SİLME İŞLEMİ EKLE");
                                          context
                                              .read<BrandProvider>()
                                              .deleteBrand(
                                                  id: item!.id.toString());
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text("KATEGORİ BULUNAMADI"),
              ),

        /*   */
      ),
    );
  }

  void _showForm(BuildContext ctx, var itemKey, var index,
      List<CategoryModel?> brandModel) {
    final provider = context.read<BrandProvider>();
    final _currencyFormat = NumberFormat("#,##0.00", "tr_TR");

    if (itemKey != null) {
      _titleController.text = brandModel[index]!.name.toString();
    }
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15),
            child: Form(
              key: provider.formGlobalKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _firstTextFieldFocusNode.unfocus();
                      // İkinci TextField'a geçiş
                      FocusScope.of(context)
                          .requestFocus(_secondTextFieldFocusNode);
                    },
                    focusNode: _firstTextFieldFocusNode,
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Marka Adı'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _titleController.clear();
                                /*  _descriptionController.clear();
                                _barcodeController.clear();
                                _priceController.clear();
                                selectedValue = null; */
                              });
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Exit")),
                        ElevatedButton(
                          onPressed: () {
                            if (itemKey != null) {
                              context.read<CategoryProvider>().updateCategory(
                                  id: context
                                      .read<CategoryProvider>()
                                      .categoryList[index]!
                                      .id
                                      .toString(),
                                  key: "name",
                                  value: _titleController.text);
                              Navigator.of(context).pop();
                              return;
                            }
                            final category = CategoryModel(
                              name: _titleController.text,
                              id: const Uuid().v4(),
                              status: "1",
                            );
                            context
                                .read<CategoryProvider>()
                                .addCategory(categoryModel: category, context: context);

                            setState(() {
                              _titleController.clear();
                              _descriptionController.clear();
                              _barcodeController.clear();
                              _priceController.clear();
                              selectedValue = null;
                            });

                            Navigator.of(context).pop();
                          },
                          child:
                              Text(itemKey == null ? 'Create New' : 'Update'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            )));
  }
}

class NotionScreen extends StatelessWidget {
  const NotionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              // 'İlan' bloğuna tıklandığında yapılacak işlemler
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.adb,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'İlan',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // 'Kişisel' bloğuna tıklandığında yapılacak işlemler
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.person,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kişisel',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // 'İş' bloğuna tıklandığında yapılacak işlemler
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.work,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'İş',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
