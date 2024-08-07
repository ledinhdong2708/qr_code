import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class _GrpoDetailState extends State<GrpoDetail> with RouteAware{
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
    slThucTeController = TextEditingController(text: '0');
    uoMCodeController = TextEditingController(text: widget.uoMCode);
    remakeController = TextEditingController(text: widget.remake);
    _fetchData();
  }

  Future<void> _fetchData() async {
    print('fetch data');
    fetchGrpoItemsDetailData(widget.docEntry, widget.lineNum).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          grpoItemsDetail = data['data'];
          print('Fetched data: $grpoItemsDetail'); // In ra dữ liệu để kiểm tra
          double totalSlThucTe = 0.0;

          if (grpoItemsDetail.isNotEmpty) {
            for (var item in grpoItemsDetail) {
              double slThucTe = 0.0;
              if (item['SlThucTe'] != null) {
                slThucTe += double.tryParse(item['SlThucTe'].toString()) ?? 0.0;
              } else {
                slThucTe = 0;
              }
              totalSlThucTe += slThucTe;
            }
            itemCodeController.text = grpoItemsDetail[0]['ItemCode'];
            descriptionController.text = grpoItemsDetail[0]['ItemName'];
            batchController.text = grpoItemsDetail[0]['Batch'];
            whseController.text = grpoItemsDetail[0]['Whse'];
            slThucTeController.text = totalSlThucTe.toString();
            uoMCodeController.text = grpoItemsDetail[0]['UoMCode'].toString();
            remakeController.text = grpoItemsDetail[0]['Remake'].toString();
          }
        });
      } else {
        print('Data is null or not a list');
      }
    }).catchError((error) {
      print('Error fetching data: $error');
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

      if (successfulCount == totalItems) {
        print('All data successfully sent to server');
        CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
      }
    } catch (e) {
      print('Error submitting data: $e');
    }
  }

  String _generateBatchCode() {
    final now = DateTime.now();
    final dateFormat = DateFormat('ddMMyyyy');
    final dateStr = dateFormat.format(now);

    int maxIndex = 1;
    int index = grpoItemsDetail.length;
    if (grpoItemsDetail.isNotEmpty) {
      maxIndex = index + 1;
    }
    return '${dateStr}_${maxIndex}';
  }

  void _navigateToAddNewItem() {
    final batchCode = _generateBatchCode();
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
          batch: batchCode,
        ),
      ),
    ).then((_) => _fetchData()); // Fetch data after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const HeaderApp(title: "GRPO - Details"),
        body: Container(
          color: bgColor,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
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
                controller: slYeuCauController,
                labelText: 'Số lượng yêu cầu:',
                hintText: 'Số lượng yêu cầu',
              ),
              buildTextFieldRow(
                controller: slThucTeController,
                labelText: 'Số lượng thực tế:',
                hintText: 'Số lượng thực tế',
              ),
              if (grpoItemsDetail.isNotEmpty)
                ListItems(
                  listItems: grpoItemsDetail,
                  enableDismiss: true,
                  onDeleteItem: (index) async {
                    String id = grpoItemsDetail[index]['ID'].toString();
                    await deleteGrpoItemsDetailData(id, context);
                  },
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GrpoDetailItems(
                          docEntry: widget.docEntry,
                          lineNum: widget.lineNum,
                          id: grpoItemsDetail[index]['ID'].toString(),
                          itemCode: grpoItemsDetail[index]['ItemCode'],
                          itemName: grpoItemsDetail[index]['ItemName'],
                          whse: grpoItemsDetail[index]['Whse'],
                          slThucTe: grpoItemsDetail[index]['SlThucTe'].toString(),
                          batch: grpoItemsDetail[index]['Batch'].toString(),
                          uoMCode: grpoItemsDetail[index]['UoMCode'].toString(),
                          remake: grpoItemsDetail[index]['Remake'].toString(),
                        ),
                      ),
                    );
                  },
                  labelsAndChildren: const [
                    {'label': 'ItemCode', 'child': 'ItemCode'},
                    {'label': 'Name', 'child': 'ItemName'},
                    {'label': 'Whse', 'child': 'Whse'},
                    {'label': 'Quantity', 'child': 'SlThucTe'},
                    {'label': 'UoM Code', 'child': 'UoMCode'},
                    {'label': 'Batch', 'child': 'Batch'},
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
                      text: 'New',
                      onPressed: _navigateToAddNewItem,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CustomButton(
                      text: 'OK',
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
