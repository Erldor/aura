import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RegisterResult {
  final bool success;
  final String? error;

  RegisterResult({required this.success, this.error});
}

class LoginResult {
  final bool success;
  final String? error;

  LoginResult({required this.success, this.error});
}

class PasswordUpdateResult {
  final bool success;
  final String? error;

  PasswordUpdateResult({required this.success, this.error});
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

  Future<RegisterResult> register({required String email, required String username, required String password}) async
  {
    final url = Uri.parse("$baseUrl/register");
    final response = await http.post(url, body: jsonEncode({"email": email, "password": password, "username": username}), headers: {"Content-Type": "application/json"});
    final data = jsonDecode(response.body);

    if(response.statusCode == 200)
    {
      return data["success"] ? RegisterResult(success: true) : RegisterResult(success: false, error: data["error"]);
    }

    return RegisterResult(success: false, error: "Server error");
  }

  Future<bool> updateName(String email, String newName) async
  {
    final url = Uri.parse('$baseUrl/update_name');
    final response = await http.post(url, body: jsonEncode({"email": email, "newName": newName}), headers: {"Content-Type": "application/json"});
  
    if(response.statusCode == 200)
    {
      return true;
    }
    
    return false;
  }

  Future<PasswordUpdateResult> updatePassword(String email, String old, String next) async
  {
    final url = Uri.parse('$baseUrl/update_name');
    final response = await http.post(url, body: jsonEncode({"email": email, "old": old, "new": next}), headers: {"Content-Type": "application/json"});
    final data = jsonDecode(response.body);

    if(response.statusCode == 200)
    {
      return data["success"] ? PasswordUpdateResult(success: true) : PasswordUpdateResult(success: false, error: data["error"]);
    }
    
    return PasswordUpdateResult(success: false, error: data["error"]);
  }

  
  Future<bool> uploadAvatar(String email, File imageFile) async {
    var uri = Uri.parse('$baseUrl/update_avatar');
    var request = http.MultipartRequest('POST', uri);

    // добавляем email
    request.fields['Email'] = email;

    // добавляем файл
    request.files.add(await http.MultipartFile.fromPath(
      'Avatar', // имя поля на сервере
      imageFile.path,
      filename: imageFile.path.split('/').last,
    ));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Upload success');
      return true;
    } else {
      print('Upload failed: ${response.statusCode}');
      return false;
    }
  }
}