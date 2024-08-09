import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/print_page.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GoodsReceiptInvenPrint extends StatefulWidget {
  final String id;
  final String itemCode;
  final String itemName;
  final String quantity;
  final String whse;
  final String uoMCode;
  final String batch;
  final String accountCode;
  final String sokien;




  const GoodsReceiptInvenPrint(
      {super.key,
        this.id = '',
        this.batch = '',
        this.quantity = '',
        this.itemCode = '',
        this.itemName = '',
        this.whse = '',
        this.uoMCode = '',
        this.accountCode = '',
        this.sokien = '',
      });

  @override
  // ignore: library_private_types_in_public_api
  _GoodsReceiptInvenPrintState createState() => _GoodsReceiptInvenPrintState();
}

class _GoodsReceiptInvenPrintState extends State<GoodsReceiptInvenPrint> {
  late TextEditingController _idController;
  late TextEditingController _itemCodeController;
  late TextEditingController _itemNameController;
  late TextEditingController _whseController;
  late TextEditingController _quantityController;
  late TextEditingController _batchController;
  late TextEditingController _uomController;
  late TextEditingController _accountCodeController;
  late TextEditingController _sokienController;

  // final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.id);
    _itemCodeController = TextEditingController(text: widget.itemCode);
    _itemNameController = TextEditingController(text: widget.itemName);
    _quantityController = TextEditingController(text: widget.quantity);
    _whseController = TextEditingController(text: widget.whse);
    _uomController = TextEditingController(text: widget.uoMCode);
    _batchController = TextEditingController(text: widget.batch);
    _accountCodeController = TextEditingController(text: widget.accountCode);
    _sokienController = TextEditingController(text: widget.sokien);
  }

  @override
  void dispose() {
    _batchController.dispose();
    _quantityController.dispose();
    _sokienController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderApp(title: "Goods Receipt - Detail"),
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
              controller: _quantityController,
              labelText: 'Quantity:',
              hintText: 'Quantity',
            ),
            buildTextFieldRow(
              controller: _whseController,
              labelText: 'Whse:',
              hintText: 'Whse',
            ),
            buildTextFieldRow(
              controller: _uomController,
              labelText: 'UoM Code:',
              hintText: 'UoMCode',
            ),
            buildTextFieldRow(
              controller: _batchController,
              labelText: 'Số Batch:',
              hintText: 'Batch',
            ),
            buildTextFieldRow(
              controller: _accountCodeController,
              labelText: 'Account Code:',
              hintText: 'Account Code',
            ),
            buildTextFieldRow(
              controller: _sokienController,
              labelText: 'Số kiện',
              hintText: 'Số kiện',
            ),
            const SizedBox(height: 20),
            Center(
              child: QrImageView(
                data: widget.batch,
                version: QrVersions.auto,
                size: 150.0,
              ),
            ),
            const SizedBox(height: 20),
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
                        'slThucTe': _quantityController.text,
                        'whse': _whseController.text,
                        'uoMCode': _uomController.text,
                        'batch': _batchController.text,
                        'accountCode': _accountCodeController.text,
                        'sokien': _sokienController.text,
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
