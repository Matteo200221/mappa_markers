import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CallController extends GetxController {

  RxString loginToken = ''.obs;

  Future<String> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://minimalapi20240918161622.azurewebsites.net/Login'),
        headers: <String, String>{    
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'password': password,
        }),
      );
      final responseData = jsonDecode(response.body);
      print(responseData['data']);
      return '${responseData['data']}';
    } catch (e) {
      return 'errore';
    }
  }
}