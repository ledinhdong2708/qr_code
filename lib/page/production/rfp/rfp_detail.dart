import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/list_items.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/production/rfp/rfp_add_new_detail_items.dart';
import 'package:qr_code/page/production/rfp/rfp_detail_items.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_add_new_detail_items.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_detail_items.dart';
import 'package:qr_code/service/grpo_service.dart';

import '../../../service/ifp_service.dart';
import '../../../service/rfp_service.dart';

class RfpDetail extends StatefulWidget {
  final String qrData;
  final String id;
  final String docEntry;
  final String lineNum;
  final String itemCode;
  final String description;
  final String batch;
  final String slYeuCau;
  final String whse;
  final String slThucTe;
  final String uoMCode;
  final String remake;

  const RfpDetail({
    super.key,
    required this.qrData,
    this.id = "",
    this.docEntry = "",
    this.lineNum = "",
    this.itemCode = "",
    this.whse = "",
    this.slThucTe = "",
    this.uoMCode = "",
    this.remake = "",
    this.description = "",
    this.batch = "",
    this.slYeuCau = "",
  });

  @override
  _RfpDetailState createState() => _RfpDetailState();
}

class _RfpDetailState extends State<RfpDetail> {
  List<dynamic> rfpItemsDetail = [];
  Map<String, dynamic>? owor;
  final TextEditingController _remakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _docNoController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _prodNameController = TextEditingController();
  final TextEditingController _plannedQtyController = TextEditingController();
  final TextEditingController _uomController = TextEditingController();
  final TextEditingController _warehouseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_fetchOworData();
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchOworData(widget.qrData).then((data) {
      if (data != null) {
        if (data['data'] != null && data['data']['PostDate'] != null) {
          DateTime parsedDate = DateTime.parse(data['data']['PostDate']);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          data['data']['PostDate'] = formattedDate;
        }
        setState(() {
          owor = data;
          _docNoController.text = owor?['data']['DocNum'] ?? '';
          _itemCodeController.text = owor?['data']['ItemCode'] ?? '';
          _prodNameController.text = owor?['data']['ProdName'] ?? '';
          _plannedQtyController.text = owor?['data']['PlannedQty'] ?? '';
          _uomController.text = owor?['data']['Uom'] ?? '';
          _warehouseController.text = owor?['data']['Warehouse'] ?? '';
          _remakeController.text = owor?['data']['remake'] ?? '';
          _dateController.text = owor?['data']['PostDate'] ?? '';

        });
      }
    });

    fetchRfpItemsDetailData(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          rfpItemsDetail = data['data'];
        });
      }
    });
  }

  Future<void> _fetchOworData() async {

  }


  @override
  void dispose() {
    // itemCodeController.dispose();
    // descriptionController.dispose();
    // batchController.dispose();
    // slYeuCauController.dispose();
    // whseController.dispose();
    // slThucTeController.dispose();
    // uoMCodeController.dispose();
    // remakeController.dispose();
    super.dispose();
  }


  Future<void> _submitData() async {
    int successfulCount = 0;
    int totalItems = rfpItemsDetail.length;

    try {
      for (var item in rfpItemsDetail) {
        final data = {
          'docEntry': widget.qrData,
          'lineNum': widget.lineNum,
          'itemCode': item['ItemCode'],
          'itemName': item['ItemName'],
          'batch': item['Batch'],
          'slYeuCau': widget.slYeuCau,
          'whse': item['Whse'],
          'slThucTe': item['SlThucTe'].toString(),
          'uoMCode': item['UoMCode'].toString(),
          'remake': item['Remake'].toString(),
        };

        await postRfpItemsData(data, context);
        successfulCount++;
      }

      final submitData = {
        'DocEntry':   _docNoController.text,
        'DocNum':     _docNoController.text,
        'ItemCode':   _itemCodeController.text,
        'ProdName':   _prodNameController.text,
        'PlannedQty': _plannedQtyController.text,
        'Uom':        _uomController.text,
        'Warehouse':  _warehouseController.text,
        'remake':     _remakeController.text,
        'thongtinvattu': '',
      };
      await postRfpHeaderData(submitData, context);

      if (successfulCount == totalItems) {
        print('All data successfully sent to server');
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
          onOkPressed: () {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          },
        );
      }

    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const HeaderApp(title: "RFP - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: AppStyles.paddingContainer,
          child: Column(
            children: [
              buildTextFieldRow(
                controller: _docNoController,
                labelText: 'Order No.',
                hintText: 'Order No.',
              ),
              buildTextFieldRow(
                controller: _itemCodeController,
                labelText: 'Item Code',
                hintText: 'Item Code',
              ),
              buildTextFieldRow(
                controller: _prodNameController,
                labelText: 'Product Name',
                hintText: 'Product Name',
              ),
              buildTextFieldRow(
                controller: _plannedQtyController,
                labelText: 'Planned Qty',
                hintText: 'Planned Qty',
              ),
              buildTextFieldRow(
                controller: _uomController,
                labelText: 'UoM',
                hintText: 'UoM',
              ),
              buildTextFieldRow(
                controller: _warehouseController,
                labelText: 'Warehouse',
                hintText: 'Warehouse',
              ),
              // buildTextFieldRow(
              //   controller: _remakeController,
              //   labelText: 'Remake',
              //   hintText: 'Remake',
              // ),
              if (rfpItemsDetail.isNotEmpty)
                ListItems(
                  listItems: rfpItemsDetail,
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RfpDetailItems(
                          docEntry: widget.qrData,
                          lineNum: widget.lineNum,
                          id: rfpItemsDetail[index]['ID'].toString(),
                          itemCode: rfpItemsDetail[index]['ItemCode'],
                          itemName: rfpItemsDetail[index]['ItemName'],
                          whse: rfpItemsDetail[index]['Whse'],
                          slThucTe:
                          rfpItemsDetail[index]['SlThucTe'].toString(),
                          batch: rfpItemsDetail[index]['Batch'].toString(),
                          uoMCode: rfpItemsDetail[index]['UoMCode'].toString(),
                          remake: rfpItemsDetail[index]['Remake'].toString(),
                        ),
                      ),
                    );
                  },
                  labelsAndChildren: const [
                    {'label': 'ID', 'child': 'ID'},
                    {'label': 'Batch', 'child': 'Batch'},
                    {'label': 'SlThucTe', 'child': 'SlThucTe'},
                    {'label': 'Remake', 'child': 'Remake'},
                    // Add more as needed
                  ],
                  // labelName1: 'ID',
                  // labelName2: 'Batch',
                  // labelName3: 'SlThucTe',
                  // labelName4: 'Remake',
                  // listChild1: 'ID',
                  // listChild2: 'Batch',
                  // listChild3: 'SlThucTe',
                  // listChild4: 'Remake',
                ),
              Container(
                width: double.infinity,
                margin: AppStyles.marginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'New',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RfpAddNewDetailItems(
                              docEntry: widget.qrData,
                              itemCode: _itemCodeController.text,
                              itemName: _prodNameController.text,
                              whse: _warehouseController.text,
                              uoMCode: _uomController.text,
                            ),
                          ),
                        ).then((_) => _fetchData());
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomButton(
                      text: 'ADD',
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
