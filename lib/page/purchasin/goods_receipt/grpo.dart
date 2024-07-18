import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/list_items.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/purchasin/goods_receipt/grpo_detail.dart';
import 'package:qr_code/service/grpo_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Grpo extends StatefulWidget {
  final String qrData;
  Grpo({super.key, required this.qrData});

  @override
  State<Grpo> createState() => _GrpoState();
}

class _GrpoState extends State<Grpo> {
  final TextEditingController _remakeController = TextEditingController();
  Barcode? result;
  List<dynamic> grpo = [];
  Map<String, dynamic>? opor;
  List<dynamic> por1 = [];
  @override
  void initState() {
    super.initState();

    fetchOporData(widget.qrData).then((data) {
      if (data != null) {
        setState(() {
          opor = data;
          _remakeController.text = opor?['data']['remake'] ?? '';
        });
      }
    });
    fetchPor1Data(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          por1 = data['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = opor?['data'];
    var docNum = data != null ? data['DocNum'].toString() : '';
    var docDate = data != null ? data['DocDate'].toString() : '';
    var cardCode = data != null ? data['CardCode'] : '';
    var cardName = data != null ? data['CardName'] : '';
    var remark = data != null ? data['remake'] : '';

    return Scaffold(
        appBar: const HeaderApp(title: "GRPO"),
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
                    controller: _remakeController),
                if (por1.isNotEmpty)
                  ListItems(
                      listItems: por1,
                      onTapItem: (index) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GrpoDetail(
                              docEntry: por1[index]['DocEntry'],
                              lineNum: por1[index]['LineNum'],
                              itemCode: por1[index]['ItemCode'],
                              description: por1[index]['Dscription'],
                              whse: por1[index]['WhsCode'],
                              openQty: por1[index]['OpenQty'].toString(),
                              slThucTe: por1[index]['SlThucTe'].toString(),
                              batch: por1[index]['Batch'].toString(),
                              uoMCode: por1[index]['UomCode'].toString(),
                              remake: por1[index]['remake'].toString(),
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
                          await updateGrpoDatabase(
                              widget.qrData, _remakeController.text, context);
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
