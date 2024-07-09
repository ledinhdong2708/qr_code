import 'dart:convert';

import 'package:flutter/material.dart';
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
  Barcode? result;
  List<dynamic> goodreturn = [];
  Map<String, dynamic>? oprr;
  List<dynamic> prr1 = [];
  @override
  void initState() {
    super.initState();
    fetchOprrData(widget.qrData).then((data) {
      if (data != null) {
        setState(() {
          oprr = data;
          _remakeController.text = oprr?['data']['remake'] ?? '';
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

  // Future<void> updateDatabase(String remake) async {
  //   final resultCode = widget.qrData;
  //   if (goodreturn.isEmpty) {
  //     print('No data to update');
  //     return;
  //   }
  //   var data = goodreturn[0]['data'];
  //   var updatedData = {
  //     'docno': data['docno'].toString(),
  //     'postday': data['postday'].toString(),
  //     'vendorcode': data['vendorcode'],
  //     'vendorname': data['vendorname'],
  //     'remake': remake,
  //   };
  //   var url = Uri.parse('$serverIp/api/v1/grr/$resultCode');
  //   var response = await http.put(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(updatedData),
  //   );
  //   if (response.statusCode == 200) {
  //     print('Update successful');
  //     print(updatedData);
  //     CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
  //     // setState(() {
  //     //   data['remake'] = remake;
  //     //   // _remakeController.text = remake;
  //     // });
  //   } else {
  //     print('Failed to update');
  //     CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
  //   }
  // }

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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: prr1.length,
                    itemBuilder: (context, index) {
                      var item = prr1[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoodsReturnDetail(
                                docEntry: item['DocEntry'],
                                lineNum: item['LineNum'],
                                itemCode: item['ItemCode'],
                                description: item['Dscription'],
                                whse: item['WhsCode'],
                                openQty: item['OpenQty'].toString(),
                                slThucTe: item['SlThucTe'].toString(),
                                batch: item['Batch'].toString(),
                                uoMCode: item['UomCode'].toString(),
                                remake: item['remake'].toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: readInput,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['ItemCode']),
                              Text(item['Dscription']),
                              Text(item['Batch'].toString()),
                              Text(item['OpenQty'].toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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