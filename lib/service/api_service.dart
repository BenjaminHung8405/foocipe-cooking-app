import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final storage = const FlutterSecureStorage();

  Future<dynamic> request(String serviceName, String endpoint, String method,
      {Map<String, dynamic>? bodyData}) async {
    try {
      final accessToken = await storage.read(key: 'access_token');

      if (accessToken == null) {
        print('No access token found');
        return null;
      }

      // Lấy URL từ biến môi trường dựa trên serviceName
      final apiUrl = dotenv.env[serviceName];
      if (apiUrl == null) {
        print('Service URL for $serviceName is not set in .env file');
        return null;
      }

      final uri = Uri.parse('$apiUrl$endpoint');
      final headers = {
        'access_token': accessToken,
        'Content-Type': 'application/json',
      };

      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(uri,
              headers: headers, body: json.encode(bodyData));
          break;
        case 'PUT':
          response = await http.put(uri,
              headers: headers, body: json.encode(bodyData));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'GET':
        default:
          response = await http.get(uri, headers: headers);
          break;
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during request: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> GET(
      String serviceName, String endpoint) async {
    return await request(serviceName, endpoint, 'GET');
  }

  Future<dynamic> POST(String serviceName, String endpoint,
      Map<String, dynamic> bodyData) async {
    return await request(serviceName, endpoint, 'POST', bodyData: bodyData);
  }

  Future<dynamic> PUT(String serviceName, String endpoint,
      Map<String, dynamic> bodyData) async {
    return await request(serviceName, endpoint, 'PUT', bodyData: bodyData);
  }

  Future<dynamic> DELETE(String serviceName, String endpoint) async {
    return await request(serviceName, endpoint, 'DELETE');
  }
}
