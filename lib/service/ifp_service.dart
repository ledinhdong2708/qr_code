import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../component/dialog.dart';
import '../constants/urlAPI.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> fetchOworData(String resultCode) async {
  final url = '$serverIp/api/v1/owor/$resultCode';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      //print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching OPOR data: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> fetchWor1Data(String resultCode) async {
  final url = '$serverIp/api/v1/wor1/$resultCode';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch POR1 data successful");
      // print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching POR1 data: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> fetchIfpItemsDetailTempData(
    String docentry, String linenum) async {
  final url = '$serverIp/api/v1/ifpitemdetailtemp/Detail/$docentry/$linenum';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch ifpitemdetailtemp data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching ifpitemdetailtemp data: $e");
    return null;
  }
}

Future<void> postIfpItemsDetailTempData(Map<String, dynamic> data,
    BuildContext context, String docentry, String linenum) async {
  final String url = '$serverIp/api/v1/ifpitemdetailtemp/$docentry/$linenum';
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

Future<void> postIfpItemsDetailData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/ifpitemdetail';
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

Future<void> deleteIfpItemsDetailTempData(String id, BuildContext context) async {
  final String url = '$serverIp/api/v1/ifpitemdetailtemp/$id';
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

Future<void> postIfpHeaderData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/ifpheader';
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
      CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
        onOkPressed: () {
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 0);
        },
      );
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      CustomDialog.showDialog(context, 'Cập nhật thất bại!', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}

Future<void> updateIfpHeaderDatabase(
    String resultCode, String remake, String docDate, BuildContext context) async {
  final data = await fetchOworData(resultCode);
  print(data);
  if (data == null || data.isEmpty) {
    print('No data to update');
    return;
  }

  var updatedData = {
    'DocEntry': data['data']['DocEntry'].toString(),
    'DocNum': data['data']['DocNum'].toString(),
    'PostDate': docDate,
    'ItemCode': data['data']['ItemCode'],
    'ProdName': data['data']['ProdName'],
    'remake': remake,
  };

  var url = Uri.parse('$serverIp/api/v1/ifpheader');
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

Future<Map<String, dynamic>?> fetchIfpHeaderData() async {
  final url = '$serverIp/api/v1/ifpheader';
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

