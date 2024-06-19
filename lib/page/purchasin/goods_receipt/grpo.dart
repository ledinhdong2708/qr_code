import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:qr_code/component/button.dart';
import 'package:qr_code/component/date_input.dart';
import 'package:qr_code/component/header_app.dart';
import 'package:qr_code/component/textfield_method.dart';
import 'package:qr_code/constants/UrlApi.dart';
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
  Barcode? result;
  List<dynamic> grpo = [];
  @override
  void initState() {
    super.initState();
    fetchGrpoData();
  }

  // void fetchGrpoData() async {
  //   final resultCode = widget.qrData;
  //   print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //   print(resultCode);
  //   const url = 'https://localhost:7245/api/Opor/1';
  //   final uri = Uri.parse(url);
  //   print(url);
  //   try {
  //     final response = await http.get(uri);
  //     if (response.statusCode == 200) {
  //       final body = response.body;
  //       final json = jsonDecode(body);
  //       print("thành công");
  //       setState(() {
  //         grpo.add(json);
  //       });
  //       print(grpo);
  //     } else {
  //       print("Failed to load data with status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Exception caught: $e");
  //   }
  // }

  void fetchGrpoData() async {
    final resultCode = widget.qrData;
    print(resultCode);
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    final url = '$serverIp/api/Opor/$resultCode';
    final uri = Uri.parse(url);
    print(url);
    print(uri);
      try {
        final response = await http.get(uri);
        print(response);
        if (response.statusCode == 200) {
          final body = response.body;
          final json = jsonDecode(body);
          print("thành công");
          setState(() {
            grpo.add(json);
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

  @override
  Widget build(BuildContext context) {
    var docNum = grpo.isNotEmpty ? grpo[0]['docNum'].toString() : '';
    var docDate = grpo.isNotEmpty ? grpo[0]['docDate'].toString() : '';
    var cardCode = grpo.isNotEmpty ? grpo[0]['cardCode'] : '';
    var cardName = grpo.isNotEmpty ? grpo[0]['cardName'] : '';
    var remark = grpo.isNotEmpty ? grpo[0]['remark'] : '';
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
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.grpoDetail);
                  },
                  child: const Text('Xem Chi Tiết'),
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
                        onPressed: () {},
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
