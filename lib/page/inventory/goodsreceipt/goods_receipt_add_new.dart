import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/inventory/goodsreceipt/goods_receipt_print.dart';
import 'package:qr_code/page/inventory/goodsreceipt/list_itemcode.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:qr_code/service/goods_receipt_inven_service.dart';

import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../inventorytransfer/list_warehouses.dart';

class GoodsReceiptInvenAddNew extends StatefulWidget {
  late String itemCode;
  late String itemName;
  final String batch;
  GoodsReceiptInvenAddNew({super.key, this.itemCode = '', this.itemName = '', this.batch = ''});

  @override
  _GoodsReceiptInvenAddNewState createState() => _GoodsReceiptInvenAddNewState();

}

class _GoodsReceiptInvenAddNewState extends State<GoodsReceiptInvenAddNew> {
  //List<dynamic> goodsReceiptInvenItemsDetail = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _whseController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _uomController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  void _handleItemSelected(String itemCode, String itemName) {
    setState(() {
      _itemCodeController.text = itemCode;
      _itemNameController.text = itemName;
      //widget.itemCode = itemCode;
      //_fetchData();
    });
  }
  void _handleWarehouseSelected(String whsCode) {
    setState(() {
      _whseController.text = whsCode;
      //widget.itemCode = itemCode;
      //_fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    // if (widget.itemCode != '') {
    //   _itemCodeController.text = widget.itemCode;
    //   _itemNameController.text = widget.itemName;
    //   _fetchData();
    // }
    _batchController.text = widget.batch;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _batchController.dispose();
    _priceController.dispose();
    _reasonController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final itemsData = {
      'PostDate': _dateController.text,
      'ItemCode': _itemCodeController.text,
      'ItemName': _itemNameController.text,
      'Remake': _remarkController.text,
    };
    final itemsDetailData = {
      'PostDate': _dateController.text,
      'ItemCode': _itemCodeController.text,
      'ItemName': _itemNameController.text,
      'Whse': _whseController.text,
      'Quantity': _quantityController.text,
      'Batch': _batchController.text,
      'uoMCode': _uomController.text,
      'Price': _priceController.text,
      'Total': _totalController.text,
      'Lydonhapkho': _reasonController.text,
      'Remake': _remarkController.text,
    };
    try {
      await postGoodsReceiptInvenItemsData(itemsData, context);
      await postGoodsReceiptInvenItemsDetailData(itemsDetailData, context);
      if (context.mounted) {
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
          onOkPressed: () {
            Navigator.of(context).pop(true); // Pass a value to indicate success
          },
        );
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  // Future<void> _fetchData() async {
  //   fetchGoodsReceiptInvenItemsDetailData().then((data) {
  //     if (data != null && data['data'] is List) {
  //       setState(() {
  //         goodsReceiptInvenItemsDetail = data['data'];
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String docDate = formatter.format(now);
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
        appBar: const HeaderApp(title: "Goods Receipt - New"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
            child: ListView(
              children: [
                DateInput(
                  postDay: docDate,
                  controller: _dateController,
                ),
                buildTextFieldRow(
                  labelText: 'Item Code:',
                  hintText: 'Item Code',
                  controller: _itemCodeController,
                  iconButton: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListItemcode(
                            onItemSelected: _handleItemSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                buildTextFieldRow(
                  labelText: 'Item Name:',
                  hintText: 'Item Name',
                  controller: _itemNameController,
                ),
                buildTextFieldRow(
                    labelText: 'Whse:',
                    hintText: 'Whse',
                    controller: _whseController,
                  iconButton: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListWarehouses(
                            onItemSelected: _handleWarehouseSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                buildTextFieldRow(
                    labelText: 'Quantity:',
                    hintText: 'Quantity',
                    controller: _quantityController,
                    isEnable: true),
                buildTextFieldRow(
                    labelText: 'Batch:',
                    hintText: 'Batch',
                    controller: _batchController
                ),
                buildTextFieldRow(
                    labelText: 'UoM Code:',
                    hintText: 'UoM Code',
                    controller: _uomController
                ),
                buildTextFieldRow(
                    labelText: 'Price:',
                    hintText: 'Price',
                    controller: _priceController,
                    isEnable: true
                ),
                buildTextFieldRow(
                    labelText: 'Total:',
                    hintText: 'Total',
                    controller: _totalController,
                ),
                Dropdownbutton(
                  items: ['Lý do a', 'Lý do b', 'Lý do c'],
                  labelText: 'Lý do nhập kho',
                  hintText: 'Lý do nhập kho',
                  controller: _reasonController,
                ),
                buildTextFieldRow(
                  labelText: 'Remarks',
                  isEnable: true,
                  hintText: 'Remarks here',
                  icon: Icons.edit,
                  controller: _remarkController,
                ),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'OK',
                        onPressed: _submitData,
                      ),
                    ],
                  ),
                )
              ],
            ),
        ));
  }
}
