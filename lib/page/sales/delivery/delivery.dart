import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/sales/delivery/delivery_detail.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import '../../../component/dialog.dart';
import '../../../component/list_items.dart';
import '../../../constants/urlAPI.dart';
import '../../../service/delivery_service.dart';



class Delivery extends StatefulWidget {
  final String qrData;
  const Delivery({super.key, required this.qrData});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final TextEditingController _remakeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Barcode? result;
  List<dynamic> delivery = [];
  Map<String, dynamic>? ordr;
  List<dynamic> rdr1 = [];
  @override
  void initState() {
    super.initState();
    fetchOrdrData(widget.qrData).then((data) {
      if (data != null) {
        if (data['data'] != null && data['data']['DocDate'] != null) {
          DateTime parsedDate = DateTime.parse(data['data']['DocDate']);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          data['data']['DocDate'] = formattedDate;
        }
        setState(() {
          ordr = data;
          _remakeController.text = ordr?['data']['remake'] ?? '';
          _dateController.text = ordr?['data']['DocDate'] ?? '';
        });
      }
    });
    fetchRdr1Data(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          rdr1 = data['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = ordr?['data'];
    var docNum = data != null ? data['DocNum'].toString() : '';
    var docDate = data != null ? data['DocDate'].toString() : '';
    var cardCode = data != null ? data['CardCode'] : '';
    var cardName = data != null ? data['CardName'] : '';
    var remark = data != null ? data['remake'] : '';

    return Scaffold(
        appBar: const HeaderApp(title: "Delivery"),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: bgColor,
          padding: AppStyles.paddingContainer,
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
                if (rdr1.isNotEmpty)
                  ListItems(
                      listItems: rdr1,
                      onTapItem: (index) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryDetail(
                              docEntry: rdr1[index]['DocEntry'],
                              lineNum: rdr1[index]['LineNum'],
                              itemCode: rdr1[index]['ItemCode'],
                              description: rdr1[index]['Dscription'],
                              whse: rdr1[index]['WhsCode'],
                              slYeuCau: rdr1[index]['OpenQty'].toString(),
                              slThucTe: rdr1[index]['SlThucTe'].toString(),
                              batch: rdr1[index]['Batch'].toString(),
                              uoMCode: rdr1[index]['UomCode'].toString(),
                              remake: rdr1[index]['remake'].toString(),
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
                        text: 'DELETE',
                        onPressed: () {},
                      ),
                      CustomButton(
                        text: 'POST',
                        onPressed: () async {
                          await updateDeliveryDatabase(
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
        ));
  }
}