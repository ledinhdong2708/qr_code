// lib/fetch_data.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/constants/popCount.dart';
import 'package:qr_code/constants/urlApi.dart';

import '../component/dialog.dart';

Future<Map<String, dynamic>?> fetchOrdrData(String resultCode) async {
  final url = '$serverIp/api/v1/ordr/$resultCode';
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
    print("Error fetching ORDR data: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> fetchRdr1Data(String resultCode) async {
  final url = '$serverIp/api/v1/rdr1/$resultCode';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch RDR1 data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching RDR1 data: $e");
    return null;
  }
}

Future<void> fetchAndUpdateDeliveryDatabase(
    String resultCode,
    TextEditingController controller,
    Function setStateCallback,
    BuildContext context) async {
  final data = await fetchOrdrData(resultCode);
  if (data != null) {
    setStateCallback(() {
      controller.text = data['data']['remake'] ?? '';
      controller.text = data['data']['postday'] ?? '';
    });

    final remake = controller.text;
    final docDate = controller.text;
    await updateDeliveryDatabase(resultCode, remake, docDate, context);
  } else {
    print('Failed to fetch data');
  }
}

Future<void> updateDeliveryDatabase(String resultCode, String remake,
    String docDate, BuildContext context) async {
  final data = await fetchOrdrData(resultCode);
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

  var url = Uri.parse('$serverIp/api/v1/delivery');
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
  const String url = '$serverIp/api/v1/deliveryitems';

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

Future<void> postDeliveryItemsData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/deliveryitems';
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

Future<void> postDeliveryItemsDetailData(Map<String, dynamic> data,
    BuildContext context, String docentry, String linenum) async {
  final String url = '$serverIp/api/v1/deliveryitemsdetail/$docentry/$linenum';
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

Future<Map<String, dynamic>?> fetchDeliveryItemsDetailData(
    String docentry, String linenum) async {
  final url = '$serverIp/api/v1/deliveryitemsdetail/Detail/$docentry/$linenum';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch deliveryitemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching deliveryitemsdetail data: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> fetchQRDeliveryItemsDetailData(
    String docentry, String linenum, String id) async {
  final url = '$serverIp/api/v1/grpoitemsdetail/$docentry/$linenum/$id';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch QR deliveryitemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching QR deliveryitemsdetail data: $e");
    return null;
  }
}

Future<void> deleteDeliveryItemsDetailData(
    String id, BuildContext context) async {
  final String url = '$serverIp/api/v1/deliveryitemsdetail/$id';
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
//                              Fetch data of sale order
// ===================================================================================

Future<Map<String, dynamic>?> fetchSaleOrderData(
    String resultCode, BuildContext context) async {
  final url = '$serverIpSap/SAP_SaleOrder/$resultCode';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Fetch SaleOrder data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print("Error fetching SaleOrder data: $e");
    return null;
  }
}
