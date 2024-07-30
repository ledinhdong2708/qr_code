import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../component/dialog.dart';
import '../constants/urlAPI.dart';
import 'package:http/http.dart' as http;



Future<Map<String, dynamic>?> fetchOitmPagniData(int page, int pageSize) async {
  final url = '$serverIp/api/v1/oitm?page=$page&pageSize=$pageSize';
  final uri = Uri.parse(url);

  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch OITM data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching OITM data: $e");
    return null;
  }
}
Future<Map<String, dynamic>?> fetchOitmData() async {
  const url = '$serverIp/api/v1/oitm'; // Adjust URL as needed
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch OITM data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching OITM data: $e");
    return null;
  }
}

// Goods Receipt Inventory Items Detail
Future<void> postGoodsReceiptInvenItemsDetailData(Map<String, dynamic> data,
    BuildContext context) async {
  const String url = '$serverIp/api/v1/goodsreceiptinvenitemsdetail';
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
      // CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
      //   onOkPressed: () {
      //     int count = 0;
      //     Navigator.of(context).popUntil((_) => count++ >= 1);
      //   },
      // );
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

Future<Map<String, dynamic>?> fetchGoodsReceiptInvenItemsDetailData() async {
  final url = '$serverIp/api/v1/goodsreceiptinvenitemsdetail';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch goodsreceiptinvenitemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching goodsreceiptinvenitemsdetail data: $e");
    return null;
  }
}

Future<void> postGoodsReceiptInvenItemsData(Map<String, dynamic> data,
    BuildContext context) async {
  final String url = '$serverIp/api/v1/goodsreceiptinvenitems';
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
      // CustomDialog.showDialog(context, 'Cập nhật thành công!', 'success',
      //   onOkPressed: () {
      //     int count = 0;
      //     Navigator.of(context).popUntil((_) => count++ >= 1);
      //   },
      // );
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

Future<Map<String, dynamic>?> fetchGoodsReceiptInvenItemsData() async {
  final url = '$serverIp/api/v1/goodsreceiptinvenitems';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch goodsreceiptinvenitems data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching goodsreceiptinvenitems data: $e");
    return null;
  }
}