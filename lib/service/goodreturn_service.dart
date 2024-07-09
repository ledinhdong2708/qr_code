// lib/fetch_data.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qr_code/constants/urlApi.dart';

Future<Map<String, dynamic>?> fetchOprrData(String resultCode) async {
  final url = '$serverIp/api/v1/oprr/$resultCode';
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
    print("Error fetching OPRR data: $e");
    return null;
  }
}

Future<Map<String, dynamic>?> fetchPrr1Data(String resultCode) async {
  final url = '$serverIp/api/v1/prr1/$resultCode';
  final uri = Uri.parse(url);
  try {
    final response = await http.get(uri);
    var decodedResponse = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final json = jsonDecode(decodedResponse);
      print("Fetch PRR1 data successful");
      return json;
    } else {
      print("Failed to load data with status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error fetching PRR1 data: $e");
    return null;
  }
}
