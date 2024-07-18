import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/page/sales/returns/sales_return_detail.dart';
import 'package:qr_code/routes/routes.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../component/list_items.dart';
import '../../../service/sales_return_service.dart';

class SalesReturn extends StatefulWidget {
  final String qrData;

  const SalesReturn({super.key, required this.qrData});

  @override
  State<SalesReturn> createState() => _SalesReturnState();

}

class _SalesReturnState extends State<SalesReturn> {
  final TextEditingController _remakeController = TextEditingController();
  Barcode? result;
  List<dynamic> sales_return = [];
  Map<String, dynamic>? orrr;
  List<dynamic> rrr1 = [];
  @override
  void initState() {
    super.initState();
    fetchOrrrData(widget.qrData).then((data) {
      if (data != null) {
        setState(() {
          orrr = data;
          _remakeController.text = orrr?['data']['remake'] ?? '';
        });
      }
    });
    fetchRrr1Data(widget.qrData).then((data) {
      if (data != null && data['data'] is List) {
        setState(() {
          rrr1 = data['data'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = orrr?['data'];
    var docNum = data != null ? data['DocNum'].toString() : '';
    var docDate = data != null ? data['DocDate'].toString() : '';
    var cardCode = data != null ? data['CardCode'] : '';
    var cardName = data != null ? data['CardName'] : '';
    var remark = data != null ? data['remake'] : '';

    return Scaffold(
        appBar: const HeaderApp(title: "Sales Return"),
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
                if (rrr1.isNotEmpty)
                  ListItems(
                      listItems: rrr1,
                      onTapItem: (index) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesReturnDetail(
                              docEntry: rrr1[index]['DocEntry'],
                              lineNum: rrr1[index]['LineNum'],
                              itemCode: rrr1[index]['ItemCode'],
                              description: rrr1[index]['Dscription'],
                              whse: rrr1[index]['WhsCode'],
                              openQty: rrr1[index]['OpenQty'].toString(),
                              slThucTe: rrr1[index]['SlThucTe'].toString(),
                              batch: rrr1[index]['Batch'].toString(),
                              uoMCode: rrr1[index]['UomCode'].toString(),
                              remake: rrr1[index]['remake'].toString(),
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
                          await updateSrrDatabase(
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
