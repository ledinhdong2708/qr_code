import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dropdownbutton.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/qr_input.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/inventory/goodsissue/goods_issue_detail_item.dart';
import 'package:qr_code/routes/routes.dart';

import '../../../component/dialog.dart';
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
  late TextEditingController itemCodeController;
  late TextEditingController descriptionController;
  late TextEditingController batchController;
  late TextEditingController slYeuCauController;
  late TextEditingController whseController;
  late TextEditingController slThucTeController;
  late TextEditingController uoMCodeController;
  late TextEditingController remakeController;
  @override
  void initState() {
    super.initState();
    // itemCodeController = TextEditingController(text: widget.itemCode);
    // descriptionController = TextEditingController(text: widget.description);
    // batchController = TextEditingController(text: widget.batch);
    // slYeuCauController = TextEditingController(text: widget.slYeuCau);
    // whseController = TextEditingController(text: widget.whse);
    // slThucTeController = TextEditingController(text: widget.slThucTe);
    // uoMCodeController = TextEditingController(text: widget.uoMCode);
    // remakeController = TextEditingController(text: widget.remake);
    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchGoodsIssueItemsData().then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          goodsIssueInvenItemsDetail = data['data'];
          // if (goodsIssueInvenItemsDetail.isNotEmpty) {
          //   itemCodeController.text = goodsIssueInvenItemsDetail[0]['ItemCode'];
          //   descriptionController.text = goodsIssueInvenItemsDetail[0]['ItemName'];
          //   batchController.text = goodsIssueInvenItemsDetail[0]['Batch'];
          //   whseController.text = goodsIssueInvenItemsDetail[0]['Whse'];
          //   slThucTeController.text = goodsIssueInvenItemsDetail[0]['SlThucTe'].toString();
          //   uoMCodeController.text = goodsIssueInvenItemsDetail[0]['UoMCode'].toString();
          //   remakeController.text = goodsIssueInvenItemsDetail[0]['Remake'].toString();
          // }
        });
      }
    });
  }

  Future<void> _submitData() async {
    int successfulCount = 0;
    int totalItems = goodsIssueInvenItemsDetail.length;

    try {
      for (var item in goodsIssueInvenItemsDetail) {
        final data = {
          'docEntry': widget.docEntry,
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

        await postGoodsIssueInvenItemsData(data, context);
        successfulCount++;
      }

      // Check if all items were successfully submitted
      if (successfulCount == totalItems) {
        print('All data successfully sent to server');
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var docDate = '';
    return Scaffold(
        appBar: const HeaderApp(title: "Goods Issue"),
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
                          )),
                    ).then((_) => _fetchData());
                  },
                ),
              ),
              if (goodsIssueInvenItemsDetail.isNotEmpty)
                ListItems(
                  listItems: goodsIssueInvenItemsDetail,
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoodsIssueDetailItem(
                          isEditable: false,
                          id: goodsIssueInvenItemsDetail[index]['ID'].toString(),
                          itemCode: goodsIssueInvenItemsDetail[index]['ItemCode'],
                          description: goodsIssueInvenItemsDetail[index]['ItemName'],
                          whse: goodsIssueInvenItemsDetail[index]['Whse'],
                          slThucTe: goodsIssueInvenItemsDetail[index]['SlThucTe'].toString(),
                          batch: goodsIssueInvenItemsDetail[index]['Batch'].toString(),
                          uoMCode: goodsIssueInvenItemsDetail[index]['UoMCode'].toString(),
                          remake: goodsIssueInvenItemsDetail[index]['Remake'].toString(),
                        ),
                      ),
                    );
                  },
                  labelName1: 'ItemCode',
                  labelName2: 'Batch',
                  labelName3: 'SlThucTe',
                  labelName4: 'Remake',
                  listChild1: 'ItemCode',
                  listChild3: 'Batch',
                  listChild2: 'SlThucTe',
                  listChild4: 'Remake',
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
