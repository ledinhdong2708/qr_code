import 'dart:convert';

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