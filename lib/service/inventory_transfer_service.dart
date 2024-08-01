import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../component/dialog.dart';
import '../constants/urlAPI.dart';

Future<Map<String, dynamic>?> fetchQRInventoryTransferData(
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

Future<Map<String, dynamic>?> fetchOwhsData() async {
  const url = '$serverIp/api/v1/owhs'; // Adjust URL as needed
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch OWHS data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching OWHS data: $e");
    return null;
  }
}
Future<void> postInventoryTransferItemsData(Map<String, dynamic> data,
    BuildContext context, String docentry, String linenum) async {
  final String url = '$serverIp/api/v1/inventorytransferitems/$docentry/$linenum';
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

Future<Map<String, dynamic>?> fetchInventoryTransferItemsData() async {
  const url = '$serverIp/api/v1/inventorytransferitems';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch inventorytransferitems data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching inventorytransferitems data: $e");
    return null;
  }
}
