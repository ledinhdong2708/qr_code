// lib/fetch_data.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/component/dialog.dart';
import 'package:qr_code/constants/urlApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<Map<String, dynamic>?> fetchGrpoData(String docentry) async {
  final url = '$serverIp/api/v1/grpo/docentry/$docentry';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch grpo data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching grpo data: $e");
    return null;
  }
}

Future<void> postOpdnData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/opdn';
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
      // CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<Map<String, dynamic>?> fetchOpdnData(String resultCode) async {
  final url = '$serverIp/api/v1/opdn/$resultCode';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching Opdn data: $e");
    return null;
  }
}

Future<void> postPdn1Data(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/pdn1';
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
      // CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<void> updatePor1Data(
    Map<String, dynamic> data, BuildContext context, String docentry) async {
  final String url = '$serverIp/api/v1/por1/$docentry';
  try {
    var response = await http.put(
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
      // CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during PUT request: $e');
  }
}

// ===================================================================================
//                              Save SessionID to SharedPreferences
// ===================================================================================
Future<void> saveSessionId(String sessionId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('sessionId', sessionId);
}

// ===================================================================================
//                              Save SessionID to SharedPreferences
// ===================================================================================
Future<String?> getSessionId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('sessionId');
}

// ===================================================================================
//                              Fetch data of purchase order
// ===================================================================================
Future<Map<String, dynamic>?> fetchPoData(
    String resultCode, BuildContext context) async {
  String? sessionId = await getSessionId();
  if (sessionId == null) {
    print("Session ID is not available. Attempting to login again.");

    sessionId = await getSessionId();
    if (sessionId == null) {
      print("Failed to acquire new session ID.");
      return null;
    }
  }
  final url = '$serverIpSap/SAP_PurchaseOrders/$resultCode';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': "B1SESSION=$sessionId",
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
  String? sessionId = await getSessionId();
  if (sessionId == null) {
    print("Session ID is not available. Attempting to login again.");
    sessionId = await getSessionId();
    if (sessionId == null) {
      print("Failed to acquire new session ID.");
      return;
    }
  }
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
