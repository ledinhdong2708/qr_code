import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/list_items.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/production/ifp/ifp_detail_items.dart';
import 'package:qr_code/service/grpo_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../service/ifp_service.dart';

class IfpDetail extends StatefulWidget {
  final String qrData;
  final String docEntry;
  const IfpDetail({super.key, required this.qrData, this.docEntry = ""});

  @override
  State<IfpDetail> createState() => _IfpDetailState();
}

class _IfpDetailState extends State<IfpDetail> {
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _docNoController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();

  Barcode? result;
  List<dynamic> grpo = [];
  Map<String, dynamic>? owor;
  List<dynamic> wor1 = [];

  late TextEditingController productCodeController;
  late TextEditingController itemNameController;
  late TextEditingController postDayController;
  late TextEditingController docNoController;
  late TextEditingController docEntryController;
  late TextEditingController baseEntryController;
  late TextEditingController remakeController;
  @override
  void initState() {
    super.initState();



    _fetchOworData();
    _fetchWor1Data();
  }

  Future<void> _fetchOworData() async {
    fetchOworData(widget.qrData).then((data) {
      if (data != null) {
        if (data['data'] != null && data['data']['PostDate'] != null) {
          DateTime parsedDate = DateTime.parse(data['data']['PostDate']);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          data['data']['PostDate'] = formattedDate;
        }
        setState(() {
          owor = data;
          _remarksController.text = owor?['data']['remake'] ?? '';
          _dateController.text = owor?['data']['PostDate'] ?? '';
        });
      }
    });
  }

  Future<void> _fetchWor1Data() async {
    fetchWor1Data(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          wor1 = data['data'];
          print("hello:  $wor1");
        });
      }
    });
  }

  @override
  void dispose() {
    productCodeController.dispose();
    itemNameController.dispose();
    postDayController.dispose();
    docNoController.dispose();
    docEntryController.dispose();
    _remarksController.dispose();
    baseEntryController.dispose();
    super.dispose();
  }

  // Future<void> _submitData2() async {
  //   try {
  //     for (var item in wor1) {
  //       final data = {
  //         'ItemCode': item['ItemCode'],
  //         'Dscription': item['Dscription'],
  //         'Quantity': item['OpenQty'],
  //         'WhsCode': item['WhsCode'],
  //         'LineNum': item['LineNum'],
  //         'BaseEntry': item['DocEntry'],
  //         'BaseLine': item['LineNum'],
  //         'DocEntry': item['DocEntry'],
  //         'BaseType': item['ObjType']
  //       };
  //       await postPdn1Data(data, context);
  //     }
  //   } catch (e) {
  //     print('Error submitting data: $e');
  //   }
  // }

  Future<void> _submitData() async {
    try {
      var data = owor?['data'];
      var docNum = data != null ? data['DocNum'].toString() : '';
      var itemCode = data != null ? data['ItemCode'] : '';
      var prodName = data != null ? data['ProdName'] : '';
        final submitData = {
          'DocEntry': docNum,
          'DocNum': docNum,
          'PostDate': _dateController.text,
          'ItemCode': itemCode,
          'ProdName': prodName,
          'remake': _remarksController.text,
          'thongtinvattu': '',
        };
        await postIfpHeaderData(submitData, context);
      }
    catch (e) {
    print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = owor?['data'];
    var docNum = data != null ? data['DocNum'].toString() : '';
    var docDate = data != null ? data['DocDate'].toString() : '';
    var itemCode = data != null ? data['ItemCode'] : '';
    var prodName = data != null ? data['ProdName'] : '';
    var remark = data != null ? data['remake'] : '';

    return Scaffold(
        appBar: const HeaderApp(title: "Issue for Production - PO"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: bgColor,
          padding: AppStyles.paddingContainer,
          child: ListView(
            children: [
              buildTextFieldRow(
                labelText: 'Order No:',
                hintText: 'Order No',
                valueQR: docNum,
                //controller: _docNoController
              ),
              DateInput(
                postDay: docDate,
                controller: _dateController,
              ),
              buildTextFieldRow(
                labelText: 'Product Code:',
                hintText: 'Product Code',
                valueQR: itemCode,
                //controller: _productCodeController
              ),
              buildTextFieldRow(
                labelText: 'Product Name:',
                hintText: 'Product Name',
                valueQR: prodName,
                //controller: _itemNameController
              ),
              buildTextFieldRow(
                  labelText: 'Remarks:',
                  isEnable: true,
                  hintText: 'Remarks here',
                  icon: Icons.edit,
                  valueQR: remark,
                  controller: _remarksController),
              if (wor1.isNotEmpty)
                ListItems(
                    listItems: wor1,
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IfpDetailItems(
                            docEntry: wor1[index]['DocEntry'],
                            lineNum: wor1[index]['LineNum'],
                            itemCode: wor1[index]['ItemCode'],
                            description: wor1[index]['ItemName'],
                            whse: wor1[index]['WareHouse'],
                            slYeuCau: wor1[index]['PlannedQty'].toString(),
                            slThucTe: wor1[index]['SlThucTe'].toString(),
                            batch: wor1[index]['Batch'].toString(),
                            uoMCode: wor1[index]['UomCode'].toString(),
                            remake: wor1[index]['remake'].toString(),
                          ),
                        ),
                      );
                    },
                  labelsAndChildren: const [
                    {'label': 'ItemCode', 'child': 'ItemCode'},
                    {'label': 'Name', 'child': 'ItemName'},
                    {'label': 'Whse', 'child': 'WareHouse'},
                    {'label': 'Quantity', 'child': 'PlannedQty'},
                    {'label': 'UoM Code', 'child': 'UomCode'},
                  ],
                ),
              Container(
                width: double.infinity,
                margin: AppStyles.marginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // CustomButton(
                    //   text: 'Add to Sap',
                    //   onPressed: addToSap,
                    // ),
                    CustomButton(
                      text: 'POST',
                      onPressed: _submitData
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
