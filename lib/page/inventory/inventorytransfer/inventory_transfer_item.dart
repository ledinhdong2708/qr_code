import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/component/list_warehouses.dart';
import 'package:qr_code/service/inventory_transfer_service.dart';
import '../../../service/goodreturn_service.dart';
import '../../../service/qr_service.dart';


class InventoryTransferItem extends StatefulWidget {
  final String qrData;
  final String id;
  final String docEntry;
  final String lineNum;
  final String itemCode;
  final String itemName;
  final String quantity;
  final String fromWhse;
  final String toWhse;
  final String uoMCode;
  final String batch;
  final String sokien;
  final bool isEditable;
  const InventoryTransferItem(
      {super.key,
        this.qrData = '',
        this.id = '',
        this.docEntry = '',
        this.lineNum = '',
        this.batch = '',
        this.quantity = '',
        this.itemCode = '',
        this.itemName = '',
        this.fromWhse = '',
        this.toWhse = '',
        this.uoMCode = '',
        this.sokien = '',
        this.isEditable = true,
      });

  @override
  _InventoryTransferItemState createState() => _InventoryTransferItemState();
}

class _InventoryTransferItemState extends State<InventoryTransferItem> {
  Map<String, dynamic>? GRPO_QR;
  late String id;
  late String docEntry;
  late String lineNum;
  late TextEditingController idController;
  late TextEditingController batchController;
  late TextEditingController quantityController;
  late TextEditingController sokienController;
  late TextEditingController itemCodeController;
  late TextEditingController itemNameController;
  late TextEditingController fromWhseController;
  late TextEditingController toWhseController;
  late TextEditingController uoMCodeController;
  bool isLoading = true;
  bool isConfirmEnabled = false;

  void _handleItemSelected(String whsCode) {
    setState(() {
      toWhseController.text = whsCode;
      //widget.itemCode = itemCode;
      //_fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    batchController = TextEditingController();
    quantityController = TextEditingController();
    sokienController = TextEditingController();
    itemCodeController = TextEditingController();
    itemNameController = TextEditingController();
    fromWhseController = TextEditingController();
    toWhseController = TextEditingController();
    uoMCodeController = TextEditingController();
    //print("data ${widget.qrData}");
    if (widget.qrData.isNotEmpty) {
      // If QR data is provided, fetch data
      final extractedValues  = extractValuesFromQRData(widget.qrData);
      id = extractedValues['id'] ?? '';
      docEntry = extractedValues['docEntry'] ?? '';
      lineNum = extractedValues['lineNum'] ?? '';
        fetchQRInventoryTransferData(docEntry, lineNum, id).then((data) {
          if (data != null && data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
            final itemData = data['data'][0];
            setState(() {
              GRPO_QR = itemData;
              itemCodeController.text = itemData['ItemCode']?.toString() ?? '';
              itemNameController.text = itemData['ItemName']?.toString() ?? '';
              batchController.text = itemData['Batch']?.toString() ?? '';
              fromWhseController.text = itemData['Whse']?.toString() ?? '';
              quantityController.text = itemData['SlThucTe']?.toString() ?? '';
              uoMCodeController.text = itemData['UoMCode']?.toString() ?? '';
              sokienController.text = itemData['Remake']?.toString() ?? '';
              isLoading = false;
              isConfirmEnabled = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
    } else {
      setState(() {
        isLoading = false;
        idController = TextEditingController(text: widget.id);
        itemCodeController = TextEditingController(text: widget.itemCode);
        itemNameController = TextEditingController(text: widget.itemName);
        batchController = TextEditingController(text: widget.batch);
        fromWhseController = TextEditingController(text: widget.fromWhse);
        toWhseController = TextEditingController(text: widget.toWhse);
        quantityController = TextEditingController(text: widget.quantity);
        uoMCodeController = TextEditingController(text: widget.uoMCode);
        sokienController = TextEditingController(text: widget.sokien);
        isConfirmEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    batchController.dispose();
    quantityController.dispose();
    sokienController.dispose();
    itemCodeController.dispose();
    itemNameController.dispose();
    fromWhseController.dispose();
    toWhseController.dispose();
    uoMCodeController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (toWhseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a To Warehouse.')),
      );
      return;
    }

    final data = {
      'DocEntry': docEntry,
      'LineNum': lineNum,
      'ItemCode': itemCodeController.text,
      'ItemName': itemNameController.text,
      'Quantity': quantityController.text,
      'FromWhse': fromWhseController.text,
      'ToWhse': toWhseController.text,
      'UoMCode': uoMCodeController.text,
      'Batch': batchController.text,
      'Sokien': sokienController.text,
    };

    print(data);

    try {
      await postInventoryTransferItemsData(data, context, docEntry, lineNum);
      print(data);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const HeaderApp(title: "Inventoty Transfer - Detail"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: bgColor,
        padding: AppStyles.paddingContainer,
        child: ListView(
          children: [
            buildTextFieldRow(
              controller: itemCodeController,
              labelText: 'Item Code:',
              hintText: 'Item Code',
            ),
            buildTextFieldRow(
              controller: itemNameController,
              labelText: 'Item Name:',
              hintText: 'Item Name',
            ),
            buildTextFieldRow(
              controller: quantityController,
              labelText: 'Quantity:',
              hintText: 'Quantity',
            ),
            buildTextFieldRow(
              controller: fromWhseController,
              labelText: 'From Whse:',
              hintText: 'From Whse',
            ),
            buildTextFieldRow(
              labelText: 'To Whse:',
              hintText: 'To Whse',
              controller: toWhseController,
              iconButton: IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListWarehouses(
                        onItemSelected: _handleItemSelected,
                      ),
                    ),
                  );
                },
              ),
            ),
            buildTextFieldRow(
              controller: uoMCodeController,
              labelText: 'UoM Code:',
              hintText: 'UoMCode',
            ),
            buildTextFieldRow(
              controller: batchController,
              labelText: 'Số Batch:',
              hintText: 'Batch',
            ),
            buildTextFieldRow(
              controller: sokienController,
              labelText: 'Số kiện',
              hintText: 'Số kiện',
              isEnable: widget.isEditable,
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
                    text: 'OK',
                    isEnabled: isConfirmEnabled,
                    // onPressed: _submitData,
                    onPressed: _submitData,

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
