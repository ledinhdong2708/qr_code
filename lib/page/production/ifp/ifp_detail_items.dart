import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/production/ifp/ifp_add_new_detail_items.dart';
import 'package:qr_code/service/ifp_service.dart';
import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../qr_view_example.dart';


class IfpDetailItems extends StatefulWidget {
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

  const IfpDetailItems({
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
  _IfpDetailItemsState createState() => _IfpDetailItemsState();
}

class _IfpDetailItemsState extends State<IfpDetailItems> {
  List<dynamic> ifpItemsDetail = [];
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
    fetchIfpItemsDetailTempData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          ifpItemsDetail = data['data'];
          double totalSlThucTe = 0.0;

          if (ifpItemsDetail.isNotEmpty) {
            for (var item in ifpItemsDetail) {
              double slThucTe = 0.0;
              if (item['SlThucTe'] != null) {
                slThucTe += double.tryParse(item['SlThucTe'].toString()) ?? 0.0;
              }
              totalSlThucTe += slThucTe;
            }
            itemCodeController.text = ifpItemsDetail[0]['ItemCode'];
            descriptionController.text = ifpItemsDetail[0]['ItemName'];
            batchController.text = ifpItemsDetail[0]['Batch'];
            whseController.text = ifpItemsDetail[0]['Whse'];
            slThucTeController.text = totalSlThucTe.toString();
            uoMCodeController.text = ifpItemsDetail[0]['UoMCode'].toString();
            remakeController.text = ifpItemsDetail[0]['Remake'].toString();
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
    int totalItems = ifpItemsDetail.length;

    try {
      for (var item in ifpItemsDetail) {
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

        await postIfpItemsDetailData(data, context);
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
        appBar: const HeaderApp(title: "IFP - Detail - Items"),
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
              buildTextFieldRow(
                controller: slThucTeController,
                labelText: 'SL Thực Tế',
                hintText: 'SL Thực Tế',
                isEnable: true,
                iconButton: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRViewExample(
                            pageIdentifier: 'IfpAddNewDetailItems',
                            docEntry: widget.docEntry,
                            lineNum: widget.lineNum,
                          )),
                    ).then((_) => _fetchData());
                  },
                ),
              ),
              if (ifpItemsDetail.isNotEmpty)
                ListItems(
                  listItems: ifpItemsDetail,
                  enableDismiss: true,
                  onDeleteItem: (index) async {
                    String id = ifpItemsDetail[index]['ID'].toString();
                    await deleteIfpItemsDetailTempData(id, context);
                  },
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IfpAddNewDetailItems(
                          isEditable: false,
                          id: ifpItemsDetail[index]['ID'].toString(),
                          itemCode: ifpItemsDetail[index]['ItemCode'],
                          itemName: ifpItemsDetail[index]['ItemName'],
                          whse: ifpItemsDetail[index]['Whse'],
                          slThucTe:
                          ifpItemsDetail[index]['SlThucTe'].toString(),
                          batch: ifpItemsDetail[index]['Batch'].toString(),
                          uoMCode:
                          ifpItemsDetail[index]['UoMCode'].toString(),
                          remake: ifpItemsDetail[index]['Remake'].toString(),
                        ),
                      ),
                    );
                  },
                  labelName1: 'Whse',
                  labelName2: 'Batch',
                  labelName3: 'SlThucTe',
                  labelName4: 'Remake',
                  listChild1: 'Whse',
                  listChild2: 'Batch',
                  listChild3: 'SlThucTe',
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
        ));
  }
}
