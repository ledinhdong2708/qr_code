
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../component/dialog.dart';
import '../constants/urlAPI.dart';
import 'package:http/http.dart' as http;

Future<void> postGoodsIssueInvenItemsDetailData(Map<String, dynamic> data,
    BuildContext context, String docentry, String linenum) async {
  final String url = '$serverIp/api/v1/goodsissueinvenitemsdetail/$docentry/$linenum';
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Data successfully sent to server');
      CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
        onOkPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        },
      );

    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error',
        onOkPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        },
      );
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<Map<String, dynamic>?> fetchGoodsIssueItemsData() async {
  final url = '$serverIp/api/v1/goodsissueinvenitems/';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch goodsissueinvenitems data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching goodsissueinvenitems data: $e");
    return null;
  }
}

Future<void> postGoodsIssueInvenItemsData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/goodsissueinvenitems';
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Data successfully sent to server');
      CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
        onOkPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        },
      );

    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error',
        onOkPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        },
      );
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<Map<String, dynamic>?> fetchGoodsIssueItemsDetailData() async {
  final url = '$serverIp/api/v1/goodsissueinvenitemsdetail/';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch goodsissueinvenitemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching goodsissueinvenitemsdetail data: $e");
    return null;
  }
}

// QR quet ma batch tu grpo sang goodissue
Future<Map<String, dynamic>?> fetchQRGoodsIssueItemsDetailData(
    String docentry, String linenum, String id) async {
  final url = '$serverIp/api/v1/grpoitemsdetail/$docentry/$linenum/$id';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch QR goodsissueitemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching QR goodsissueitemsdetail data: $e");
    return null;
  }
}