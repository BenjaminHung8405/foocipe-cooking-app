import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final storage = const FlutterSecureStorage();

  Future<dynamic> request(String endpoint, String method,
      {Map<String, dynamic>? bodyData}) async {
    try {
      final accessToken = await storage.read(key: 'access_token');

      if (accessToken == null) {
        print('No access token found');
        return null;
      }

      final uri = Uri.parse('${dotenv.env['API_URL']}$endpoint');
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
        return json.decode(response.body);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during request: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> GET() async {
    return await request('/v1', 'GET');
  }

  Future<dynamic> POST(Map<String, dynamic> bodyData) async {
    return await request('/v1', 'POST', bodyData: bodyData);
  }

  Future<dynamic> PUT(String id, Map<String, dynamic> bodyData) async {
    return await request('/v1/$id', 'PUT', bodyData: bodyData);
  }

  Future<dynamic> DELETE(String id) async {
    return await request('/v1/$id', 'DELETE');
  }
}
