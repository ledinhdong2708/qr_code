// lib/fetch_data.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_code/constants/urlApi.dart';

Future<Map<String, dynamic>?> fetchOporData(String resultCode) async {
  final url = '$serverIp/api/v1/opor/$resultCode';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      // print(json);
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

Future<Map<String, dynamic>?> fetchPor1Data(String resultCode) async {
  final url = '$serverIp/api/v1/por1/$resultCode';
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
