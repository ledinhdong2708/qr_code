import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/inventory/goodsissue/goods_issue_detail_item.dart';

import '../../../component/dialog.dart';
import '../../../component/dropdownbutton.dart';
import '../../../component/list_items.dart';
import '../../../service/goods_issue_inven_service.dart';
import '../../qr_view_example.dart';

class GoodsIssueInven extends StatefulWidget {
  final String docEntry;
  final String lineNum;
  final String itemCode;
  final String description;
  final String batch;
  final String openQty;
  final String whse;
  final String slYeuCau;
  final String slThucTe;
  final String uoMCode;
  final String remake;
  const GoodsIssueInven({
    super.key,
    this.docEntry = "",
    this.lineNum = "",
    this.itemCode = "",
    this.whse = "",
    this.slYeuCau = "",
    this.slThucTe = "",
    this.uoMCode = "",
    this.remake = "",
    this.description = "",
    this.batch = "",
    this.openQty = "",
  });

  @override
  _GoodsIssueInvenState createState() => _GoodsIssueInvenState();
}

class _GoodsIssueInvenState  extends State<GoodsIssueInven> {
  List<dynamic> goodsIssueInvenItemsDetail = [];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController itemQRController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchGoodsIssueItemsDetailData().then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          goodsIssueInvenItemsDetail = data['data'];
        });
      }
    });
  }

  Future<void> _submitData() async {
    int successfulCount = 0;
    int totalItems = goodsIssueInvenItemsDetail.length;

    try {
      for (var item in goodsIssueInvenItemsDetail) {
        String docEntry = item['DocEntry'].toString();
        String lineNum = item['LineNum'].toString();
        final data = {
          'DocEntry': docEntry,
          'LineNum': lineNum,
          'PostDay': _dateController.text,
          'Lydoxuatkho': _reasonController.text,
          'Remarks': _remarksController.text,
          'ItemCode': item['ItemCode'],
          'ItemName': item['ItemName'],
          'Quantity': item['Quantity'],
          'Whse': item['Whse'],
          'UoMCode': item['UoMCode'],
          'Batch': item['Batch'],
          'AccountCode': item['AccountCode'].toString(),
          'Sokien': item['Sokien'].toString(),
        };

        await postGoodsIssueInvenItemsData(data, context, docEntry, lineNum);
        String id = item['ID'].toString();
        await deleteGoodsIssueInvenItemsDetailData(id, context);
        successfulCount++;
      }

      // Check if all items were successfully submitted
      if (successfulCount == totalItems) {
        print('All data successfully sent to server');
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
        _fetchData();
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String docDate = formatter.format(now);
    return Scaffold(
        appBar: const HeaderApp(title: "Good Issue"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: Column(
            children: [
              DateInput(
                postDay: docDate,
                controller: _dateController,
              ),
              buildTextFieldRow(
                controller: itemQRController,
                labelText: 'Item',
                hintText: 'Item Code',
                iconButton: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRViewExample(
                            pageIdentifier: 'GoodsIssueDetailItem',
                          )
                      ),
                    ).then((_) => _fetchData());
                  },
                ),
              ),
              // Dropdownbutton(
              //   items: ['Lý do a', 'Lý do b', 'Lý do c'],
              //   labelText: 'Lý do xuất kho:',
              //   hintText: 'Lý do xuất kho',
              //   controller: _reasonController,
              // ),
              buildTextFieldRow(
                labelText: 'Lý do xuất kho:',
                isEnable: true,
                hintText: 'Lý do xuất kho',
                controller: _reasonController,
              ),
              buildTextFieldRow(
                labelText: 'Remarks:',
                isEnable: true,
                hintText: 'Remarks here',
                icon: Icons.edit,
                controller: _remarksController,
              ),
              if (goodsIssueInvenItemsDetail.isNotEmpty)
                ListItems(
                  listItems: goodsIssueInvenItemsDetail,
                  enableDismiss: true,
                  onDeleteItem: (index) async {
                    String id = goodsIssueInvenItemsDetail[index]['ID'].toString();
                    await deleteGoodsIssueInvenItemsDetailData(id, context);
                  },
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoodsIssueDetailItem(
                          isEditable: false,
                          id: goodsIssueInvenItemsDetail[index]['ID'].toString(),
                          itemCode: goodsIssueInvenItemsDetail[index]['ItemCode'],
                          itemName: goodsIssueInvenItemsDetail[index]['ItemName'],
                          whse: goodsIssueInvenItemsDetail[index]['Whse'],
                          quantity: goodsIssueInvenItemsDetail[index]['Quantity'].toString(),
                          batch: goodsIssueInvenItemsDetail[index]['Batch'].toString(),
                          uoMCode: goodsIssueInvenItemsDetail[index]['UoMCode'].toString(),
                          accountCode: goodsIssueInvenItemsDetail[index]['AccountCode'].toString(),
                          sokien: goodsIssueInvenItemsDetail[index]['Sokien'].toString(),
                        ),
                      ),
                    );
                  },
                  labelsAndChildren: const [
                    {'label': 'Item Code', 'child': 'ItemCode'},
                    {'label': 'Item Name', 'child': 'ItemName'},
                    {'label': 'Batch', 'child': 'Batch'},
                    {'label': 'Quantity', 'child': 'Quantity'},
                    // Add more as needed
                  ],
                ),
              Container(
                width: double.infinity,
                margin: AppStyles.marginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'POST',
                      onPressed: _submitData,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
