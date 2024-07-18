// lib/fetch_data.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/constants/urlApi.dart';

import '../component/dialog.dart';

Future<Map<String, dynamic>?> fetchOrrrData(String resultCode) async {
  final url = '$serverIp/api/v1/orrr/$resultCode';
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
    print("Error fetching ORRR data: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> fetchRrr1Data(String resultCode) async {
  final url = '$serverIp/api/v1/rrr1/$resultCode';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch RRR1 data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching RRR1 data: $e");
    return null;
  }
}

Future<void> fetchAndUpdateSrrDatabase(
    String resultCode,
    TextEditingController controller,
    Function setStateCallback,
    BuildContext context) async {
  final data = await fetchOrrrData(resultCode);
  if (data != null) {
    setStateCallback(() {
      controller.text = data['data']['remake'] ?? '';
      controller.text = data['data']['postday'] ?? '';
    });

    final remake = controller.text;
    final docDate = controller.text;
    await updateSrrDatabase(resultCode, remake, docDate, context);
  } else {
    print('Failed to fetch data');
  }
}

Future<void> updateSrrDatabase(
    String resultCode, String remake, String docDate, BuildContext context) async {
  final data = await fetchOrrrData(resultCode);
  if (data == null || data.isEmpty) {
    print('No data to update');
    return;
  }

  var updatedData = {
    'docentry': data['data']['DocEntry'].toString(),
    'docno': data['data']['DocNum'].toString(),
    'postday': docDate,
    'vendorcode': data['data']['CardCode'],
    'vendorname': data['data']['CardName'],
    'remake': remake,
  };

  var url = Uri.parse('$serverIp/api/v1/srr');
  var response = await http.post(
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
  } else {
    print('Failed to update');
    CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
  }
}

Future<void> postData(Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/srritems';

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
      CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<void> postSrrItemsData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/srritems';
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

Future<void> postSrrItemsDetailData(Map<String, dynamic> data,
    BuildContext context, String docentry, String linenum) async {
  final String url = '$serverIp/api/v1/srritemsdetail/$docentry/$linenum';
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
        Navigator.of(context).popUntil((_) => count++ >= 1);
      },
      );
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error',
      onOkPressed: () {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 1);
      },
      );
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<Map<String, dynamic>?> fetchSrrItemsDetailData(
    String docentry, String linenum) async {
  final url = '$serverIp/api/v1/srritemsdetail/Detail/$docentry/$linenum';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch srritemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching srritemsdetail data: $e");
    return null;
  }
}



