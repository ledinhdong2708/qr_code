import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../component/dialog.dart';
import '../constants/urlAPI.dart';

Future<void> postRfpItemsDetailData(Map<String, dynamic> data,
    BuildContext context, String docentry) async {
  final String url = '$serverIp/api/v1/rfpitemsdetail/$docentry';
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
      CustomDialog.showDialog(
        context,
        'Cập nhật thành công!',
        'success',
        onOkPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 1);
        },
      );
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(
        context,
        'Cập nhật thất bại!',
        'error',
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

Future<Map<String, dynamic>?> fetchRfpItemsDetailData(
    String docentry) async {
  final url = '$serverIp/api/v1/rfpitemsdetail/Detail/$docentry';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch grpoitemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching grpoitemsdetail data: $e");
    return null;
  }
}

Future<void> postRfpItemsData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/rfpitems';
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
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<void> postRfpHeaderData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/rfpheader';
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    print(data);

    if (response.statusCode == 200) {
      print('Data successfully sent to server');
      // CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
      //   onOkPressed: () {
      //     int count = 0;
      //     Navigator.of(context).popUntil((_) => count++ >= 2);
      //   },
      // );
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}


Future<Map<String, dynamic>?> fetchRfpHeaderData() async {
  final url = '$serverIp/api/v1/rfpheader';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch ifpheaders data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching ifpheaders data: $e");
    return null;
  }
}