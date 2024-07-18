import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../../constants/urlAPI.dart';
import '../../../service/goodreturn_service.dart';
import 'goods_return_detail.dart';

class GoodsReturn extends StatefulWidget {
  final String qrData;
  const GoodsReturn({super.key, required this.qrData});

  @override
  State<GoodsReturn> createState() => _GoodsReturnState();
}

class _GoodsReturnState extends State<GoodsReturn> {
  final TextEditingController _remakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  List<dynamic> goodreturn = [];
  Map<String, dynamic>? oprr;
  List<dynamic> prr1 = [];
  @override
  void initState() {
    super.initState();
    fetchOprrData(widget.qrData).then((data) {
      if (data != null) {
        if (data['data'] != null && data['data']['DocDate'] != null) {
          DateTime parsedDate = DateTime.parse(data['data']['DocDate']);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          data['data']['DocDate'] = formattedDate;
        }
        setState(() {
          oprr = data;
          _remakeController.text = oprr?['data']['remake'] ?? '';
          _dateController.text = oprr?['data']['DocDate'] ?? '';
        });
      }
    });
    fetchPrr1Data(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          prr1 = data['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = oprr?['data'];
    var docNum = data != null ? data['DocNum'].toString() : '';
    var docDate = data != null ? data['DocDate'].toString() : '';
    var cardCode = data != null ? data['CardCode'] : '';
    var cardName = data != null ? data['CardName'] : '';
    var remark = data != null ? data['remake'] : '';

    return Scaffold(
        appBar: const HeaderApp(title: "Goods Return"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: bgColor,
          padding: AppStyles.paddingContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFieldRow(
                  labelText: 'Doc No.',
                  hintText: 'Doc No.',
                  valueQR: docNum,
                ),
                DateInput(
                  postDay: docDate,
                  controller: _dateController,
                ),
                buildTextFieldRow(
                  labelText: 'Vendor Code',
                  hintText: 'Vendor Code',
                  valueQR: cardCode,
                ),
                buildTextFieldRow(
                  labelText: 'Vendor Name',
                  hintText: 'Vendor Name',
                  valueQR: cardName,
                ),
                buildTextFieldRow(
                  labelText: 'Remake',
                  isEnable: true,
                  hintText: 'Remake here',
                  icon: Icons.edit,
                  valueQR: remark,
                  controller: _remakeController
                ),
              if (prr1.isNotEmpty)
                ListItems(
                  listItems: prr1,
                  onTapItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoodsReturnDetail(
                          docEntry: prr1[index]['DocEntry'],
                          lineNum: prr1[index]['LineNum'],
                          itemCode: prr1[index]['ItemCode'],
                          description: prr1[index]['Dscription'],
                          whse: prr1[index]['WhsCode'],
                          slYeuCau: prr1[index]['OpenQty'].toString(),
                          slThucTe: prr1[index]['SlThucTe'].toString(),
                          batch: prr1[index]['Batch'].toString(),
                          uoMCode: prr1[index]['UomCode'].toString(),
                          remake: prr1[index]['remake'].toString(),
                        ),
                      ),
                    );
                  },
                  labelName1: 'DocNo',
                  labelName2: 'Code',
                  labelName3: 'Name',
                  labelName4: 'SlYeuCau',
                  listChild1: 'DocEntry',
                  listChild2: 'ItemCode',
                  listChild3: 'Dscription',
                  listChild4: 'OpenQty'),
                Container(
                  width: double.infinity,
                  margin: AppStyles.marginButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'Delete',
                        onPressed: () {},
                      ),
                      CustomButton(
                        text: 'POST',
                        onPressed: () async {
                          await updateGrrDatabase(
                          widget.qrData,
                              _remakeController.text,
                              _dateController.text,
                              context);
                          },
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