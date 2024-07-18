import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/list_items.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_add_new_detail_items.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_detail_items.dart';
import 'package:qr_code/service/grpo_service.dart';

class GrpoDetail extends StatefulWidget {
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

  const GrpoDetail({
    super.key,
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
  _GrpoDetailState createState() => _GrpoDetailState();
}

class _GrpoDetailState extends State<GrpoDetail> {
  List<dynamic> grpoItemsDetail = [];
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
    itemCodeController = TextEditingController(text: widget.itemCode);
    descriptionController = TextEditingController(text: widget.description);
    batchController = TextEditingController(text: widget.batch);
    slYeuCauController = TextEditingController(text: widget.slYeuCau);
    whseController = TextEditingController(text: widget.whse);
    slThucTeController = TextEditingController(text: widget.slThucTe);
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);

    _fetchData();
  }

  Future<void> _fetchData() async {
    fetchGrpoItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          grpoItemsDetail = data['data'];

          if (grpoItemsDetail.isNotEmpty) {
            itemCodeController.text = grpoItemsDetail[0]['ItemCode'];
            descriptionController.text = grpoItemsDetail[0]['ItemName'];
            batchController.text = grpoItemsDetail[0]['Batch'];
            whseController.text = grpoItemsDetail[0]['Whse'];
            slThucTeController.text = grpoItemsDetail[0]['SlThucTe'].toString();
            uoMCodeController.text = grpoItemsDetail[0]['UoMCode'].toString();
            remakeController.text = grpoItemsDetail[0]['Remake'].toString();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    itemCodeController.dispose();
    descriptionController.dispose();
    batchController.dispose();
    slYeuCauController.dispose();
    whseController.dispose();
    slThucTeController.dispose();
    uoMCodeController.dispose();
    remakeController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    int successfulCount = 0;
    int totalItems = grpoItemsDetail.length;

    try {
      for (var item in grpoItemsDetail) {
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

        await postGrpoItemsData(data, context);
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
    return Scaffold(
        appBar: const HeaderApp(title: "GRPO - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: Column(
            children: [
              buildTextFieldRow(
                controller: itemCodeController,
                labelText: 'Item Code',
                hintText: 'Item Code',
              ),
              buildTextFieldRow(
                controller: descriptionController,
                labelText: 'Item Name',
                hintText: 'Item Name',
              ),
              buildTextFieldRow(
                controller: slYeuCauController,
                labelText: 'SL Yêu Cầu',
                hintText: 'SL Yêu Cầu',
              ),
              if (grpoItemsDetail.isNotEmpty)
                ListItems(
                  listItems: grpoItemsDetail,
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GrpoDetailItems(
                          id: grpoItemsDetail[index]['ID'].toString(),
                          itemCode: grpoItemsDetail[index]['ItemCode'],
                          itemName: grpoItemsDetail[index]['ItemName'],
                          whse: grpoItemsDetail[index]['Whse'],
                          slThucTe:
                              grpoItemsDetail[index]['SlThucTe'].toString(),
                          batch: grpoItemsDetail[index]['Batch'].toString(),
                          uoMCode: grpoItemsDetail[index]['UoMCode'].toString(),
                          remake: grpoItemsDetail[index]['Remake'].toString(),
                        ),
                      ),
                    );
                  },
                  labelName1: 'ID',
                  labelName2: 'Batch',
                  labelName3: 'SlThucTe',
                  labelName4: 'Remake',
                  listChild1: 'ID',
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
                      text: 'New',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GrpoAddNewDetailItems(
                              docEntry: widget.docEntry,
                              lineNum: widget.lineNum,
                              itemCode: widget.itemCode,
                              itemName: widget.description,
                              whse: widget.whse,
                              uoMCode: widget.uoMCode,
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
