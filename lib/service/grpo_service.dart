// lib/fetch_data.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/constants/popCount.dart';

import '../constants/urlAPI.dart';

Future<void> postGrpoItemsData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/grpoitems';
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

Future<void> postGrpoItemsDetailData(Map<String, dynamic> data,
    BuildContext context, String docentry, String linenum) async {
  final String url = '$serverIp/api/v1/grpoitemsdetail/$docentry/$linenum';
  print(url);
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
          Navigator.of(context).popUntil((_) => count++ >= testPopItemDetails);
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
          Navigator.of(context).popUntil((_) => count++ >= popCountItemDetails);
        },
      );
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<Map<String, dynamic>?> fetchGrpoItemsDetailData(
    String docentry, String linenum) async {
  final url = '$serverIp/api/v1/grpoitemsdetail/Detail/$docentry/$linenum';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch grpoitemsdetail data successful");
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

Future<void> deleteGrpoItemsDetailData(String id, BuildContext context) async {
  final String url = '$serverIp/api/v1/grpoitemsdetail/$id';
  try {
    var response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('Data successfully deleted');
      // CustomDialog.showDialog(context, 'Xóa thành công!', 'success',
      //   onOkPressed: () {
      //     int count = 0;
      //     Navigator.of(context).popUntil((_) => count++ >= 0);
      //   },
      // );

    } else {
      print('Failed to delete data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      // CustomDialog.showDialog(context, 'Xóa thất bại!', 'error',
      //   onOkPressed: () {
      //     int count = 0;
      //     Navigator.of(context).popUntil((_) => count++ >= 2);
      //   },
      // );
    }
  } catch (e) {
    print('Error during DELETE request: $e');
    CustomDialog.showDialog(context, 'Có lỗi xảy ra!', 'error');
  }
}

// ===================================================================================
//                              Fetch data of purchase order
// ===================================================================================
Future<Map<String, dynamic>?> fetchPoData(
    String resultCode, BuildContext context) async {
  final url = '$serverIpSap/SAP_PurchaseOrders/$resultCode';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Fetch PO data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print("Error fetching PO data: $e");
    return null;
  }
}

// ===================================================================================
//                              Post data in PO to GRPO
// ===================================================================================
Future<void> postPoToGrpo(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIpSap/SAP_PurchaseDeliveryNotes';
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      CustomDialog.showDialog(context, 'Cập nhật thành công', 'success');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

// ===================================================================================
//                              Post data in GRPO GoLang
// ===================================================================================
Future<void> postGrpo(Map<String, dynamic> data, BuildContext context) async {
  const String url = '$api/grpo';
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      CustomDialog.showDialog(context, 'Cập nhật thành công', 'success');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}
