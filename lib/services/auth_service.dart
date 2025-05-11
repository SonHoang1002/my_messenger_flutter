import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_messenger_app_flu/config/api_config.dart';
import 'package:my_messenger_app_flu/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _storage = SharedPreferencesAsync();

  Future<bool> login(String username, String password) async {
    final String loginApi =
        "${BASE_API}auth/login"; // http://127.0.0.1:8080/auth/login

    try {
      final response = await ApiConfig().doPost(
        loginApi,
        {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // mapOf(
        //       "userLoginId" to generatedId,
        //       "message" to "Login successfully",
        //       "accessToken" to accessToken,
        //       "refreshToken" to refreshToken
        //   )
        String userLoginId = responseData["userLoginId"];
        String accessToken = responseData["accessToken"];
        String refreshToken = responseData["refreshToken"];

        await _storage.setString('userLoginId', userLoginId);
        await _storage.setString('accessToken', accessToken);
        await _storage.setString('refreshToken', refreshToken);

        return true;
      } else {
        return false;
      }
    } on http.ClientException catch (e) {
      throw Exception('Lỗi kết nối: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Lỗi định dạng dữ liệu: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.getString('userLoginId');
    return token != null;
  }

  Future<void> logout() async {
    await _storage.setString('userLoginId', "");
    await _storage.setString('accessToken', "");
    await _storage.setString('refreshToken', "");
  }
}
