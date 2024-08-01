import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/print_page.dart';

class GoodsReceiptInvenPrint extends StatefulWidget {
  final String id;
  final String itemCode;
  final String itemName;
  final String whse;
  final String quantity;
  final String batch;
  final String uoMCode;
  final String price;
  final String total;
  final String reason;
  final String remark;



  const GoodsReceiptInvenPrint(
      {super.key,
        this.id = '',
        this.batch = '',
        this.quantity = '',
        this.itemCode = '',
        this.itemName = '',
        this.whse = '',
        this.uoMCode = '',
        this.remark = '',
        this.reason = '',
        this.price = '',
        this.total = '',
      });

  @override
  // ignore: library_private_types_in_public_api
  _GoodsReceiptInvenPrintState createState() => _GoodsReceiptInvenPrintState();
}

class _GoodsReceiptInvenPrintState extends State<GoodsReceiptInvenPrint> {
  // late TextEditingController idController;
  // late TextEditingController batchController;
  // late TextEditingController slThucTeController;
  // late TextEditingController remakeController;
  // late TextEditingController itemCodeController;
  // late TextEditingController descriptionController;
  // late TextEditingController whseController;
  // late TextEditingController uoMCodeController;
  late TextEditingController _idController;
  late TextEditingController _itemCodeController;
  late TextEditingController _itemNameController;
  late TextEditingController _whseController;
  late TextEditingController _quantityController;
  late TextEditingController _batchController;
  late TextEditingController _uomController;
  late TextEditingController _priceController;
  late TextEditingController _totalController;
  late TextEditingController _reasonController;
  late TextEditingController _remarkController;

  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.id);
    _itemCodeController = TextEditingController(text: widget.itemCode);
    _itemNameController = TextEditingController(text: widget.itemName);
    _batchController = TextEditingController(text: widget.batch);
    _whseController = TextEditingController(text: widget.whse);
    _quantityController = TextEditingController(text: widget.quantity);
    _uomController = TextEditingController(text: widget.uoMCode);
    _remarkController = TextEditingController(text: widget.remark);
    _priceController = TextEditingController(text: widget.price);
    _totalController = TextEditingController(text: widget.total);
    _reasonController = TextEditingController(text: widget.reason);

  }

  @override
  void dispose() {
    _batchController.dispose();
    _quantityController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Goods Receipt Detail"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: AppStyles.paddingContainer,
        child: ListView(
          children: [
            buildTextFieldRow(
              controller: _itemCodeController,
              labelText: 'Item Code',
              hintText: 'Item Code',
            ),
            buildTextFieldRow(
              controller: _itemNameController,
              labelText: 'Item Name',
              hintText: 'Item Name',
            ),
            buildTextFieldRow(
              controller: _whseController,
              labelText: 'Whse',
              hintText: 'Whse',
            ),
            buildTextFieldRow(
              controller: _uomController,
              labelText: 'UoMCode',
              hintText: 'UoMCode',
            ),
            buildTextFieldRow(
              controller: _quantityController,
              labelText: 'Sl Thực tế',
              hintText: 'Sl Thực tế',
            ),
            buildTextFieldRow(
              controller: _batchController,
              labelText: 'Batch',
              hintText: 'Batch',
            ),
            buildTextFieldRow(
              controller: _remarkController,
              labelText: 'Remake',
              hintText: 'Remake',
            ),
            Flexible(
              child: Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'PRINT',
                    onPressed: () {
                      final data = {
                        'docEntry': '',
                        'lineNum': '',
                        'id': _idController.text,
                        'itemCode': _itemCodeController.text,
                        'itemName': _itemNameController.text,
                        'whse': _whseController.text,
                        'uoMCode': _uomController.text,
                        'batch': _batchController.text,
                        'slThucTe': _quantityController.text,
                        'remake': _remarkController.text,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrintPage(data: data),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PrintPage(
                      //       data: data
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
