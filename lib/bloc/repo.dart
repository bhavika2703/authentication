import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled1/bloc/login_bloc/login_bloc.dart';

class Repo {
  final String _baseUrl = 'https://crmcomponentapi.blueflower.in/api';
  final http.Client _httpClient = http.Client();

  /* Future<http.Response> postLogin({required LoadLogin event}) async {
    final url = Uri.parse('$_baseUrl/login');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'mobile': event.user,
      'password': event.password,
    });

    final response = await _httpClient.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final token = jsonData['token'];

      return token;
    } else {
      throw Exception('Failed to login');
    }
  }*/

  getHeader(String token) async {
    Map<String, String> header = {
      'content-type': "application/json",
      "Authorization": "Bearer ${token}"
    };
    return header;
  }

  Future<http.Response> postLogin({required LoadLogin event}) async {
    final url = Uri.parse('$_baseUrl/login');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'mobile': event.user,
      'password': event.password,
    });

    final response = await _httpClient.post(url, headers: headers, body: body);

    return response;
  }

  Future<bool> logout() async {
    // Implement logout API call here
    // For now, just return true
    return true;
  }

  Future<http.Response> getContacts({
    required int pageNumber,
    required String token,
  }) async {
    final url = Uri.parse(
        'https://crmcomponentapi.blueflower.in/api/contact?page=$pageNumber&limit=10');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await _httpClient.get(url, headers: headers);
    String decodedResponse = utf8.decode(response.bodyBytes);
    print("decodedResponse:::  $decodedResponse");

    return response;
  }

  Future<http.Response> getContactDetails({
    required String id,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/contact/$id');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await _httpClient.get(url, headers: headers);

    return response;
  }
}
