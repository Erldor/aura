import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginResult {
  final bool success;
  final String? error;

  LoginResult({required this.success, this.error});
}

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<bool> getUser(String email) async {
    final url = Uri.parse("$baseUrl/check_email");
    final response = await http.post(url, body: jsonEncode({"email": email}), headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final bool exists = jsonDecode(response.body)["exists"];
      return exists;
    }

    return false;
  }

  Future<LoginResult> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(url, body: jsonEncode({"email": email, "password": password}), headers: {"Content-Type": "application/json"},);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["success"] ? LoginResult(success: true) : LoginResult(success: false, error: data["error"]);
    }
    else
    {
      return LoginResult(success: false, error: data["error"]);
    }
  } 

  Future<bool> verifyCode(String email, String code) async
  {
    final url = Uri.parse("$baseUrl/verify_code");
    final response = await http.post(url, body: jsonEncode({"email": email, "code": code}), headers: {"Content-Type": "application/json"});

    if(response.statusCode != 200)
    {
      return false;
    }
    
    return true;
  }

  Future<bool> sendCodeStatus(String email) async
  {
    final url = Uri.parse("$baseUrl/send_code");
    final response = await http.post(url, body: jsonEncode({"email": email}), headers: {"Content-Type": "application/json"});

    if(response.statusCode != 200)
    {
      return false;
    }
    
    return true;
  }

}