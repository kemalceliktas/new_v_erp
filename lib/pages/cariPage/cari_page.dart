import 'package:erp_project/models/brandModel/brand_model.dart';
import 'package:erp_project/models/cariModel/cari_model.dart';
import 'package:erp_project/models/orderModel/order_model.dart';
import 'package:erp_project/models/productModel/product_model.dart';
import 'package:erp_project/navigationmanager/navigation_manager.dart';
import 'package:erp_project/pages/cariPage/cari_detail.dart';
import 'package:erp_project/providers/brandProvider/brand_provider.dart';
import 'package:erp_project/providers/cariProvider/cari_provider.dart';
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

class CariPage extends StatefulWidget {
  const CariPage({Key? key}) : super(key: key);

  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage>
    with TickerProviderStateMixin, NavigatorManager {
  //textfield controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _cityCodeController = TextEditingController();

  var selectedValue;
  FocusNode _firstTextFieldFocusNode = FocusNode();
  FocusNode _secondTextFieldFocusNode = FocusNode();
  FocusNode _thirdTextFieldFocusNode = FocusNode();
  FocusNode _fourTextFieldFocusNode = FocusNode();
  FocusNode _fiveTextFieldFocusNode = FocusNode();
  FocusNode _sixTextFieldFocusNode = FocusNode();
  FocusNode _sevenTextFieldFocusNode = FocusNode();
  FocusNode _eightTextFieldFocusNode = FocusNode();
  FocusNode _nineTextFieldFocusNode = FocusNode();
  bool isLoadingPage = false;
  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _tcController.dispose();
    _taxNumberController.dispose();
    _cityCodeController.dispose();
    _firstTextFieldFocusNode.dispose();
    _secondTextFieldFocusNode.dispose();
    _thirdTextFieldFocusNode.dispose();
    _fourTextFieldFocusNode.dispose();
    _fiveTextFieldFocusNode.dispose();
    _sixTextFieldFocusNode.dispose();
    _sevenTextFieldFocusNode.dispose();
    _eightTextFieldFocusNode.dispose();
    _nineTextFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    context.read<CariProvider>().getAllCariler();
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
            _showForm(
                context, null, null, context.read<CariProvider>().cariList);
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
        appBar: AppBar(title: const Text("Cariler")),
        body: context.watch<CariProvider>().cariList.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context.watch<CariProvider>().cariList.length,
                      itemBuilder: (_, index) {
                        final item =
                            context.watch<CariProvider>().cariList[index];
                        return InkWell(
                          onTap: () {
                            navigateToWidgetReplacment(
                              context,
                              CariDetailPage(item: item!),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(20),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title: !context.watch<BrandProvider>().isLoading
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
                                                .read<CariProvider>()
                                                .cariList);
                                      }),
                                  // Delete button
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        StaticConst().returnDialog(
                                          message:
                                              "Cariyi silmek istediğinizden emin misiniz?",
                                          context: context,
                                          acceptFunc: () {
                                            print("SİLME İŞLEMİ EKLE");
                                            context
                                                .read<CariProvider>()
                                                .deleteCari(
                                                    id: item!.id.toString());
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text("CARİ BULUNAMADI"),
              ),

        /*   */
      ),
    );
  }

  void _showForm(
      BuildContext ctx, var itemKey, var index, List<CariModel?> brandModel) {
    final provider = context.read<CariProvider>();
    final _currencyFormat = NumberFormat("#,##0.00", "tr_TR");

    if (itemKey != null) {
      _nameController.text = brandModel[index]!.name.toString();
      _addressController.text = brandModel[index]!.address.toString();
      _cityCodeController.text = brandModel[index]!.cityCode.toString();
      _emailController.text = brandModel[index]!.email.toString();
      _lastNameController.text = brandModel[index]!.lastName.toString();
      _phoneController.text = brandModel[index]!.phone.toString();
      _taxNumberController.text = brandModel[index]!.taxNumber.toString();
      _tcController.text = brandModel[index]!.identificationNumber.toString();
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
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Cari Adı'),
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
                    controller: _lastNameController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Cari Soyisim'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _thirdTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_fourTextFieldFocusNode);
                    },
                    focusNode: _thirdTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    controller: _tcController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'TC'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _fourTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_fiveTextFieldFocusNode);
                    },
                    focusNode: _fourTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    controller: _taxNumberController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Vergi No'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _fiveTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_sixTextFieldFocusNode);
                    },
                    focusNode: _fiveTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    controller: _phoneController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Telefon No'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _sixTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_sevenTextFieldFocusNode);
                    },
                    focusNode: _sixTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'E mail'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _eightTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                      FocusScope.of(context)
                          .requestFocus(_nineTextFieldFocusNode);
                    },
                    focusNode: _eightTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    controller: _addressController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Adres'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onEditingComplete: () {
                      // Odak kaybı
                      _nineTextFieldFocusNode.unfocus();
                      // İlk TextField'a geri dönüş
                    },
                    focusNode: _nineTextFieldFocusNode,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    controller: _cityCodeController,
                    validator: (value) {
                      if (value!.isEmpty) return "Required Field";
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'City Code'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _nameController.clear();
                                _lastNameController.clear();
                                _addressController.clear();
                                _phoneController.clear();
                                _emailController.clear();
                                _tcController.clear();
                                _taxNumberController.clear();
                                _cityCodeController.clear();
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
                              context.read<CariProvider>().updateCari(
                                  id: context
                                      .read<CariProvider>()
                                      .cariList[index]!
                                      .id
                                      .toString(),
                                  key: "name",
                                  value: _nameController.text);
                              Navigator.of(context).pop();
                              return;
                            }
                            final cari = CariModel(
                              name: _nameController.text,
                              id: const Uuid().v4(),
                              status: "1",
                              type: "type",
                              lastName: _lastNameController.text,
                              address: _addressController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              identificationNumber: _tcController.text,
                              taxNumber: _taxNumberController.text,
                              cityCode: _cityCodeController.text,
                            );
                            context
                                .read<CariProvider>()
                                .addCari(cariModl: cari, context: context);

                            setState(() {
                              _nameController.clear();
                              _lastNameController.clear();
                              _addressController.clear();
                              _phoneController.clear();
                              _emailController.clear();
                              _tcController.clear();
                              _taxNumberController.clear();
                              _cityCodeController.clear();
                              selectedValue = null;
                            });

                            Navigator.of(context).pop();
                          },
                          child: Text(itemKey == null ? 'Oluştur' : 'Düzenle'),
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
