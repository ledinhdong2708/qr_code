import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import '../../../service/goodreturn_service.dart';
import '../../../service/ifp_service.dart';
import '../../../service/qr_service.dart';


class IfpAddNewDetailItems extends StatefulWidget {
  final String qrData;
  final String id;
  final String docEntry;
  final String lineNum;
  final String batch;
  final String slThucTe;
  final String remake;
  final String itemCode;
  final String itemName;
  final String whse;
  final String uoMCode;
  final bool isEditable;
  const IfpAddNewDetailItems(
      {super.key,
        this.qrData = '',
        this.id = '',
        this.docEntry = '',
        this.lineNum = '',
        this.batch = '',
        this.slThucTe = '',
        this.itemCode = '',
        this.itemName = '',
        this.whse = '',
        this.uoMCode = '',
        this.remake = '',
        this.isEditable = true,
      });

  @override
  _IfpAddNewDetailItemsState createState() => _IfpAddNewDetailItemsState();
}

class _IfpAddNewDetailItemsState extends State<IfpAddNewDetailItems> {
  Map<String, dynamic>? GRPO_QR;
  late TextEditingController idController;
  late TextEditingController batchController;
  late TextEditingController slThucTeController;
  late TextEditingController remarksController;
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController whseController;
  late TextEditingController uoMCodeController;
  bool isLoading = true;
  bool isConfirmEnabled = false;

  @override
  void initState() {
    super.initState();
    batchController = TextEditingController();
    slThucTeController = TextEditingController();
    remarksController = TextEditingController();
    itemCodeController = TextEditingController();
    descriptionController = TextEditingController();
    whseController = TextEditingController();
    uoMCodeController = TextEditingController();
    //print("data ${widget.qrData}");
    if (widget.qrData.isNotEmpty) {
      // If QR data is provided, fetch data
      final extractedValues  = extractValuesFromQRData(widget.qrData);
      String id = extractedValues['id'] ?? '';
      String docEntry = extractedValues['docEntry'] ?? '';
      String lineNum = extractedValues['lineNum'] ?? '';
      print(id);
      print(widget.docEntry);
      print(lineNum);
      if (docEntry == widget.docEntry && lineNum == widget.lineNum) {
        fetchQRGrrItemsDetailData(docEntry, lineNum, id).then((data) {
          if (data != null && data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
            final itemData = data['data'][0];
            setState(() {
              GRPO_QR = itemData;
              itemCodeController.text = itemData['ItemCode']?.toString() ?? '';
              descriptionController.text = itemData['ItemName']?.toString() ?? '';
              batchController.text = itemData['Batch']?.toString() ?? '';
              whseController.text = itemData['Whse']?.toString() ?? '';
              slThucTeController.text = itemData['SlThucTe']?.toString() ?? '';
              uoMCodeController.text = itemData['UoMCode']?.toString() ?? '';
              remarksController.text = itemData['Remake']?.toString() ?? '';
              isLoading = false;
              isConfirmEnabled = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    } else {
      setState(() {
        isLoading = false;
        idController = TextEditingController(text: widget.id);
        itemCodeController = TextEditingController(text: widget.itemCode);
        descriptionController = TextEditingController(text: widget.itemName);
        batchController = TextEditingController(text: widget.batch);
        whseController = TextEditingController(text: widget.whse);
        slThucTeController = TextEditingController(text: widget.slThucTe);
        uoMCodeController = TextEditingController(text: widget.uoMCode);
        remarksController = TextEditingController(text: widget.remake);
        isConfirmEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    batchController.dispose();
    slThucTeController.dispose();
    remarksController.dispose();
    itemCodeController.dispose();
    descriptionController.dispose();
    whseController.dispose();
    uoMCodeController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final data = {
      'itemCode': itemCodeController.text,
      'itemName': descriptionController.text,
      'whse': whseController.text,
      'uoMCode': uoMCodeController.text,
      'docEntry': widget.docEntry,
      'lineNum': widget.lineNum,
      'batch': batchController.text,
      'slThucTe': slThucTeController.text,
      'remake': remarksController.text,
    };

    try {
      await postIfpItemsDetailTempData(
          data, context, widget.docEntry, widget.lineNum);
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const HeaderApp(title: "Issue for Production - PO Detail"),
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
              controller: descriptionController,
              labelText: 'Item Name:',
              hintText: 'Item Name',
            ),
            buildTextFieldRow(
              controller: slThucTeController,
              labelText: 'Quantity:',
              hintText: 'Quantity',
            ),
            buildTextFieldRow(
              controller: whseController,
              labelText: 'Whse:',
              hintText: 'Whse',
            ),
            buildTextFieldRow(
              controller: uoMCodeController,
              labelText: 'UoM Code:',
              hintText: 'UoMCode',
            ),
            buildTextFieldRow(
              controller: batchController,
              labelText: 'Số Batch:',
              hintText: 'Số Batch',
            ),
            buildTextFieldRow(
              controller: remarksController,
              labelText: 'Số kiện:',
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
