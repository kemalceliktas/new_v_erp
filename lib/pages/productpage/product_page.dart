// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, use_build_context_synchronously

import 'package:erp_project/hive/HivetestModel/order_model.dart';
import 'package:erp_project/models/productModel/product_model.dart';
import 'package:erp_project/providers/cariProvider/cari_provider.dart';
import 'package:erp_project/providers/categoryProvider/category_provider.dart';
import 'package:erp_project/providers/productProvider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../pages/mainPage/main_page.dart';
import '../../providers/brandProvider/brand_provider.dart';
import '../../providers/hiveprovider/hive_provider.dart';
import '../../providers/provider1/provider_one.dart';
import '../../static/static_class.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  //textfield controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  //form key
  final List metrics = ["kitap", "defter", "kalem"];
  var brandValue;
  var categoryValue;
  var cariValue;
  FocusNode _firstTextFieldFocusNode = FocusNode();
  FocusNode _secondTextFieldFocusNode = FocusNode();
  FocusNode _thirdTextFieldFocusNode = FocusNode();
  FocusNode _fourTextFieldFocusNode = FocusNode();
  FocusNode _fiveTextFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _firstTextFieldFocusNode.dispose();
    _secondTextFieldFocusNode.dispose();
    _thirdTextFieldFocusNode.dispose();
    _fourTextFieldFocusNode.dispose();
    _fiveTextFieldFocusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    context.read<ProductProvider>().getAllProduct();
    context.read<BrandProvider>().getAllBrands();
    context.read<CategoryProvider>().getAllCategorys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ProviderOne>().changeBottomIndex(0);
        setState(() {
          _titleController.clear();
          _descriptionController.clear();
          _barcodeController.clear();
          _priceController.clear();
          categoryValue = null;
          brandValue = null;
        });
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showForm(context, null, null);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
        appBar: AppBar(title: const Text("ÜRÜNLER")),
        body: Column(
          children: [
            Expanded(
              child: !context.watch<ProductProvider>().isLoading
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          context.watch<ProductProvider>().productList.length,
                      itemBuilder: (_, index) {
                        final item =
                            context.watch<ProductProvider>().productList[index];
                        return ItemCardWidget(item: item!, showForm: _showForm);
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForm(BuildContext ctx, var itemKey, var index) {


     
    final provider = context.read<ProductProvider>();

    if (itemKey != null) {
      /*  _itemController.text = provider.items[index].title;
      _qtyController.text = provider.items[index].description.toString();
      _categoryController.text = provider.items[index].category; */
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
                    decoration: const InputDecoration(hintText: 'Ürün Adı'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _secondTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_thirdTextFieldFocusNode);
                    },
                    focusNode: _secondTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    controller: _barcodeController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Barkod'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    onEditingComplete: () {
                      // Odak kaybı
                      _secondTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_fourTextFieldFocusNode);
                    },
                    focusNode: _thirdTextFieldFocusNode,
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                    decoration: const InputDecoration(
                      hintText: "Fiyat",
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _secondTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_fiveTextFieldFocusNode);
                    },
                    focusNode: _fourTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: const TextInputType.numberWithOptions(),
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    controller: _descriptionController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Adet'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    hint: const Text("Marka"),
                    value: brandValue,
                    onChanged: (newValue) {
                      brandValue = newValue;
                    },
                    items: context.watch<BrandProvider>().brandList.isEmpty
                        ? null
                        : context
                            .watch<BrandProvider>()
                            .brandList
                            .map((metric) => DropdownMenuItem<String>(
                                  value: metric!.name,
                                  child: Text(metric.name.toString()),
                                ))
                            .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    hint: const Text("Kategori"),
                    value: categoryValue,
                    onChanged: (newValue) {
                      categoryValue = newValue;
                    },
                    items:
                        context.watch<CategoryProvider>().categoryList.isEmpty
                            ? null
                            : context
                                .watch<CategoryProvider>()
                                .categoryList
                                .map((metric) => DropdownMenuItem<String>(
                                      value: metric!.name,
                                      child: Text(metric.name.toString()),
                                    ))
                                .toList(),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    hint: const Text("Cari"),
                    value: cariValue,
                    onChanged: (newValue) {
                      cariValue = newValue;
                    },
                    items: context.watch<CariProvider>().cariList.isEmpty
                        ? null
                        : context
                            .watch<CariProvider>()
                            .cariList
                            .map((metric) => DropdownMenuItem<String>(
                                  value: metric!.name,
                                  child: Text(metric.name.toString()),
                                ))
                            .toList(),
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
                                _descriptionController.clear();
                                _barcodeController.clear();
                                _priceController.clear();
                                categoryValue = null;
                                brandValue = null;
                                cariValue=null;
                              });
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("ÇIKIŞ")),
                        ElevatedButton(
                          onPressed: () {
                            final product = ProductModel(
                              id: const Uuid().v4(),
                              status: "1",
                              title: _titleController.text,
                              barcode: _barcodeController.text,
                              description: "description",
                              price: _priceController.text,
                              openDate: DateTime.now().toString(),
                              cari: cariValue.toString(),
                              brand: brandValue.toString(),
                              category: categoryValue.toString(),
                            );
                           

                            context.read<ProductProvider>().addProduct(
                                productModel: product, context: context);
                            setState(() {
                              _titleController.clear();
                              _descriptionController.clear();
                              _barcodeController.clear();
                              _priceController.clear();
                              categoryValue = null;
                              brandValue = null;
                            });

                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                itemKey == null ? 'Yeni Oluştur' : 'Düzenle'),
                          ),
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



class ItemCardWidget extends StatefulWidget {
  const ItemCardWidget({super.key, required this.item, required this.showForm});
  final ProductModel item;
  final Function showForm;
  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  int index = 0;

  void addItem() {
    setState(() {
      index += 1;
    });
  }

  void decreaseIndex() {
    setState(() {
      index <= 0 ? index = 0 : index -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider=context.read<HiveProvider>();
    return Card(
      margin: const EdgeInsets.all(20),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text("${widget.item.title} - ${widget.item.barcode}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${widget.item.price?.toCurrency()}"),
            Text(StaticConst().dateFormatTr(widget.item.openDate.toString())),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    addItem();
                  },
                  icon: const Icon(Icons.add),
                ),
                Text(index.toString()),
                IconButton(
                  onPressed: () {
                    decreaseIndex();
                  },
                  icon: const Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: () async {
                    provider.box = await Hive.openBox('order_box');
                    final orderModel = OrderFinishModel(
                      id: const Uuid().v4(),
                      barcode: widget.item.barcode,
                      cari: widget.item.cari,
                      price: widget.item.price,
                      brand: widget.item.brand,
                      kategori: widget.item.category,
                      adet: index.toString(),
                    );
                    provider.box.add(orderModel);
                    context.read<HiveProvider>().getItems();
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("SEPETE EKLE"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //edit icon
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  widget.showForm(
                    context,
                    null,
                    null,
                  );
                }),
            // Delete button
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  StaticConst().returnDialog(
                      message: "Notu silmek istediğinizden emin misiniz?",
                      context: context,
                      acceptFunc: () {
                        context
                            .read<ProductProvider>()
                            .deleteProduct(id: widget.item.id.toString());
                        Navigator.of(context).pop();
                      });
                }),
          ],
        ),
      ),
    );
  }
}
