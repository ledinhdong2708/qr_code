import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/loading.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../component/list_items.dart';
import '../../../service/goodreturn_service.dart';
import 'goods_return_detail.dart';

class GoodsReturn extends StatefulWidget {
  final String qrData;
  const GoodsReturn({super.key, required this.qrData});

  @override
  State<GoodsReturn> createState() => _GoodsReturnState();
}

class _GoodsReturnState extends State<GoodsReturn> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  Map<String, dynamic>? oprr;
  List<dynamic> prr1 = [];
  List<dynamic> lines = [];
  Map<String, dynamic>? grr;
  // Map<String, dynamic>? goodReturn;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchGrrData();
  }

  Future<void> _fetchGrrData() async {
    final data = await fetchGrrData(widget.qrData, context);
    if (data != null) {
      setState(() {
        _isLoading = false;
        grr = data;
        lines = grr?["lines"] ?? [];
        print(grr);
        if (grr?['docDate'] != null) {
          _dateController.text =
              DateFormat('dd/MM/yyyy').format(DateTime.parse(grr?['docDate']));
        }
      });
    } else {
      print("Sai");
    }
  }

  Future<void> _postGrr() async {
    try {
      if (grr != null) {
        final grrData = {
          'DocEntry': grr?['docEntry'].toString(),
          'DocNo': grr?['docNum'].toString(),
          'VendorCode': grr?['cardCode'],
          'VendorName': grr?['cardName'],
          'PostDay': DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(_dateController.text)),
          'Remake': _commentController.text,
          'Lines': []
        };

        if (lines.isNotEmpty) {
          for (var item in lines) {
            final lineData = {
              'ItemCode': item['itemCode'],
              'ItemName': item['itemDescription'],
              'Quantity': item['quantity'].toString(),
              'BaseEntry': grr?['docEntry'].toString() ?? 0,
              'BaseLine': item['lineNum'].toString(),
              'WarehouseCode': item['warehouseCode'] ?? '',
              'BaseType': 234000032.toString(),
              'Batches': []
            };

            final grrItemsDetailForLine = await fetchGrrItemsDetailData(
                widget.qrData, item["lineNum"].toString());
            if (grrItemsDetailForLine != null &&
                grrItemsDetailForLine['data'] is List) {
              for (var batch in grrItemsDetailForLine['data']) {
                final batchData = {
                  // 'ItemCode': batch["ItemCode"],
                  'BatchNumber': batch["Batch"],
                  'Quantity': batch["SlThucTe"]
                };
                (lineData['Batches'] as List).add(batchData);
              }
            }

            (grrData['Lines'] as List).add(lineData);
          }

          await postGrr(grrData, context);
        } else {}
      } else {
        print('Dữ liệu đơn hàng (grr) là null');
      }
    } catch (e) {
      print('Lỗi khi gửi dữ liệu: $e');
    }
  }

  Future<void> _postGoodReturnRequestToGoodReturn() async {
    try {
      if (grr != null) {
        final goodReturnData = {
          'CardCode': grr?['cardCode'],
          'CardName': grr?['cardName'],
          'DocDate': DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(_dateController.text)),
          'Comments': _commentController.text,
          'Lines': []
        };

        if (lines.isNotEmpty) {
          for (var item in lines) {
            final lineData = {
              'ItemCode': item['itemCode'],
              'ItemDescription': item['itemDescription'],
              'Quantity': item['quantity'],
              'BaseEntry': grr?['docEntry'] ?? 0,
              'BaseLine': item['lineNum'] ?? 0,
              'WarehouseCode': item['warehouseCode'] ?? '',
              'BaseType': 234000032,
              'Batches': []
            };
            final grrItemsDetailForLine = await fetchGrrItemsDetailData(
                item?["baseEntry"].toString() ?? "",
                item["baseLine"].toString());

            if (grrItemsDetailForLine != null &&
                grrItemsDetailForLine['data'] is List) {
              for (var batch in grrItemsDetailForLine['data']) {
                final batchData = {
                  'ItemCode': batch["ItemCode"],
                  'BatchNumber': batch["Batch"],
                  'Quantity': batch["SlThucTe"]
                };
                (lineData['Batches'] as List).add(batchData);
              }
            }

            (goodReturnData['Lines'] as List).add(lineData);
          }

          await postGoodReturnRequestToGoodReturn(goodReturnData, context);
          print("Dữ liệu gửi đi: $goodReturnData");
        } else {}
      } else {
        print('Dữ liệu đơn hàng (grr) là null');
      }
    } catch (e) {
      print('Lỗi khi gửi dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var docNum = grr?['docNum']?.toString() ?? '';
    var cardCode = grr?['cardCode'] ?? '';
    var cardName = grr?['cardName'] ?? '';

    return Scaffold(
      appBar: const HeaderApp(title: "Good Return"),
      body: _isLoading
          ? const CustomLoading()
          : Container(
              width: double.infinity,
              height: double.infinity,
              color: bgColor,
              padding: AppStyles.paddingContainer,
              child: ListView(
                children: [
                  buildTextFieldRow(
                    labelText: 'Doc No:',
                    hintText: 'Doc No',
                    valueQR: docNum,
                  ),
                  DateInput(
                    controller: _dateController,
                  ),
                  buildTextFieldRow(
                    labelText: 'Vendor:',
                    hintText: 'Vendor Code',
                    valueQR: cardCode,
                  ),
                  buildTextFieldRow(
                    labelText: 'Name:',
                    hintText: 'Vendor Name',
                    valueQR: cardName,
                  ),
                  buildTextFieldRow(
                      labelText: 'Remarks:',
                      isEnable: true,
                      hintText: 'Remarks here',
                      icon: Icons.edit,
                      controller: _commentController),
                  if (lines.isNotEmpty)
                    ListItems(
                      listItems: lines,
                      onTapItem: (index) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoodsReturnDetail(
                              docEntry: lines[index]['docEntry'].toString(),
                              lineNum: lines[index]['lineNum'].toString(),
                              baseEntry: lines[index]['baseEntry'].toString(),
                              baseLine: lines[index]['baseLine'].toString(),
                              itemCode: lines[index]['itemCode'].toString(),
                              description: lines[index]['itemDescription'],
                              whse: lines[index]['warehouseCode'],
                              slYeuCau: lines[index]['quantity'].toString(),
                              slThucTe: lines[index]['SlThucTe'].toString(),
                              batch: lines[index]['Batch'].toString(),
                              uoMCode: lines[index]['uomCode'].toString(),
                              remake: lines[index]['remake'].toString(),
                            ),
                          ),
                        );
                      },
                      labelsAndChildren: const [
                        {'label': 'ItemCode', 'child': 'itemCode'},
                        {'label': 'Name', 'child': 'itemDescription'},
                        {'label': 'Whse', 'child': 'warehouseCode'},
                        {'label': 'Quantity', 'child': 'quantity'},
                        {'label': 'UoM Code', 'child': 'uomCode'},
                      ],
                    ),
                  Container(
                    width: double.infinity,
                    margin: AppStyles.marginButton,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: 'POST',
                          onPressed: _postGrr,
                        ),
                        CustomButton(
                            text: 'POST TO SAP',
                            onPressed: _postGoodReturnRequestToGoodReturn
                            // () async {
                            //   await updateGrrDatabase(
                            //       widget.qrData,
                            //       _remakeController.text,
                            //       _dateController.text,
                            //       context);
                            // },
                            ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
