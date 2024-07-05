import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/urlApi.dart';
import 'package:qr_code/constants/colors.dart';
import 'package:qr_code/constants/styles.dart';
import 'package:qr_code/routes/routes.dart';
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
  @override
  void initState() {
    super.initState();
    fetchGrpoData();
  }

  void dispose() {
    _remakeController.dispose();
    super.dispose();
  }

  void fetchGrpoData() async {
    final resultCode = widget.qrData;
    print("result code: $resultCode");
    final url = '$serverIp/api/v1/opor/$resultCode';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      print(response);
      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        print("thành công");
        print(json);
        setState(() {
          grpo.add(json);
          _remakeController.text = json['data']['remake'];
        });
      } else {
        // Xử lý nếu trả api lỗi hoặc không thành công
        print("Failed to load data with status code: ${response.statusCode}");
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print("lỗi: $e");
    }
  }

  Future<void> updateDatabase(String remake) async {
    final resultCode = widget.qrData;
    if (grpo.isEmpty) {
      print('No data to update');
      return;
    }
    var data = grpo[0]['data'];
    var updatedData = {
      'docno': data['docno'].toString(),
      'postday': data['postday'].toString(),
      'vendorcode': data['vendorcode'],
      'vendorname': data['vendorname'],
      'remake': remake,
    };
    var url = Uri.parse('$serverIp/api/v1/grpo/$resultCode');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedData),
    );
    if (response.statusCode == 200) {
      print('Update successful');
      print(updatedData);
      CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
      // setState(() {
      //   data['remake'] = remake;
      //   // _remakeController.text = remake;
      // });
    } else {
      print('Failed to update');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = grpo.isNotEmpty ? grpo[0]['data'] : null;

    var docNum = data != null ? data['DocNum'].toString() : '';
    var docDate = data != null ? data['DocDate'].toString() : '';
    var cardCode = data != null ? data['CardCode'] : '';
    var cardName = data != null ? data['CardName'] : '';
    var remark = data != null ? data['remake'] : '';

    // var resultCode = widget.qrData;
    // List<dynamic> result = jsonDecode(resultCode);
    // var docNum = result != null ? result[0]['DocNum'].toString() : '';
    // var docDate = result != null ? result[0]['DocDate'].toString() : '';
    // var cardCode = result != null ? result[0]['CardCode'] : '';
    // var cardName = result != null ? result[0]['CardName'] : '';
    // var remark = "";
    // var items = result != null ? result[0]['Items'] : '';
    // print(resultCode);
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
                  // controller: _remakeController
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.grpoDetail);
                    },
                    child: const Text('Xem Chi Tiết'),
                  ),
                ),
                // Column(
                //   children: [
                //     for (var item in result[0]['Items'])
                //       Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.all(10),
                //         margin: const EdgeInsets.all(10),
                //         decoration: const BoxDecoration(
                //           color: Colors.red,
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(10),
                //           ),
                //         ),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(item['ItemCode']),
                //             Text(item['Dscription']),
                //             Text(item['Quantity'].toString()),
                //             Text(item['GTotal'].toString()),
                //           ],
                //         ),
                //       )
                //   ],
                // ),

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
                          await updateDatabase(_remakeController.text);
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
