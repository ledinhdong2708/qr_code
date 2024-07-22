import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';

import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../../service/goodreturn_service.dart';
import '../../qr_view_example.dart';
import 'goods_return_detail_item.dart';

class GoodsReturnDetail extends StatefulWidget {
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

  const GoodsReturnDetail({
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
  _GoodReturnDetailState createState() => _GoodReturnDetailState();
}

class _GoodReturnDetailState extends State<GoodsReturnDetail> {
  List<dynamic> grrItemsDetail = [];
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
    fetchGrrItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          grrItemsDetail = data['data'];

          if (grrItemsDetail.isNotEmpty) {
            itemCodeController.text = grrItemsDetail[0]['ItemCode'];
            descriptionController.text = grrItemsDetail[0]['ItemName'];
            batchController.text = grrItemsDetail[0]['Batch'];
            whseController.text = grrItemsDetail[0]['Whse'];
            slThucTeController.text = grrItemsDetail[0]['SlThucTe'].toString();
            uoMCodeController.text = grrItemsDetail[0]['UoMCode'].toString();
            remakeController.text = grrItemsDetail[0]['Remake'].toString();
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
    int totalItems = grrItemsDetail.length;

    try {
      for (var item in grrItemsDetail) {
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

        await postGrrItemsData(data, context);
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
        appBar: const HeaderApp(title: "Goods Return - Detail"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
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
                buildTextFieldRow(
                  controller: slThucTeController,
                  labelText: 'SL Thực Tế',
                  hintText: 'SL Thực Tế',
                  isEnable: true,
                  iconButton: IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      //_navigateAndDisplaySelection(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRViewExample(
                                  pageIdentifier: 'GoodReturnDetailItems',
                                  docEntry: widget.docEntry,
                                  lineNum: widget.lineNum,
                                )),
                      ).then((_) => _fetchData());
                    },
                  ),
                ),
                if (grrItemsDetail.isNotEmpty)
                  ListItems(
                    listItems: grrItemsDetail,
                    onTapItem: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoodReturnDetailItems(
                            isEditable: false,
                            id: grrItemsDetail[index]['ID'].toString(),
                            itemCode: grrItemsDetail[index]['ItemCode'],
                            itemName: grrItemsDetail[index]['ItemName'],
                            whse: grrItemsDetail[index]['Whse'],
                            slThucTe:
                                grrItemsDetail[index]['SlThucTe'].toString(),
                            batch: grrItemsDetail[index]['Batch'].toString(),
                            uoMCode:
                                grrItemsDetail[index]['UoMCode'].toString(),
                            remake: grrItemsDetail[index]['Remake'].toString(),
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
          ),
        ));
  }
}
