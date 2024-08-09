// lib/fetch_data.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code/constants/urlApi.dart';
import '../component/dialog.dart';



Future<void> postGrrItemsData(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIp/api/v1/grritems';
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

Future<void> postGrrItemsDetailData(Map<String, dynamic> data,
    BuildContext context, String docentry, String linenum) async {
  final String url = '$serverIp/api/v1/grritemsdetail/$docentry/$linenum';
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

Future<Map<String, dynamic>?> fetchGrrItemsDetailData(
    String docentry, String linenum) async {
  final url = '$serverIp/api/v1/grritemsdetail/Detail/$docentry/$linenum';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch grritemsdetail data successful");
      print(json);
      print(uri);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching grritemsdetail data: $e");
    return null;
  }
}

// QR quet ma batch tu grpo sang grr
Future<Map<String, dynamic>?> fetchQRGrrItemsDetailData(
    String docentry, String linenum, String id) async {
  final url = '$serverIp/api/v1/grpoitemsdetail/$docentry/$linenum/$id';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch QR grritemsdetail data successful");
      print(json);
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching QR grritemsdetail data: $e");
    return null;
  }
}

Future<void> deleteGrrItemsDetailData(String id, BuildContext context) async {
  final String url = '$serverIp/api/v1/grritemsdetail/$id';
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
//                              Fetch data of good return request
// ===================================================================================
Future<Map<String, dynamic>?> fetchGrrData(
    String resultCode, BuildContext context) async {
  final url = '$serverIpSap/SAP_GoodReturnRequest/$resultCode';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Fetch Grr data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print("Error fetching Grr data: $e");
    return null;
  }
}

// ===================================================================================
//                              Fetch data of GrpoBatchLine
// ===================================================================================
Future<Map<String, dynamic>?> fetchGrpoBatchesLineData(
    String resultCode, BuildContext context) async {
  final url = '$serverIpSap/SAP_PurchaseDeliveryNotes/$resultCode';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print("Fetch GrpoBatchLine data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print("Error fetching GrpoBatchLine data: $e");
    return null;
  }
}

// ===================================================================================
//                              Post data in Grr GoLang
// ===================================================================================
Future<void> postGrr(Map<String, dynamic> data, BuildContext context) async {
  const String url = '$api/grr';
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
//                              Post data in GoodReturnRequest to GoodReturn
// ===================================================================================
Future<void> postGoodReturnRequestToGoodReturn(
    Map<String, dynamic> data, BuildContext context) async {
  const String url = '$serverIpSap/SAP_GoodReturn';
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
      CustomDialog.showDialog(
          context, 'Cập nhật thất bại! ${response.body}', 'error');
    }
  } catch (e) {
    print('Error during POST request: $e');
  }
}
