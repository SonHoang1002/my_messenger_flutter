import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_messenger_app_flu/config/constant.dart';

class ApiConfig {
  static const int timeoutDuration = TIMEOUT_DURATION;

  // Phương thức POST cơ bản
  Future<http.Response> doPost(
    String pathApi,
    Map<String, dynamic> data, {
    Map<String, String>? customHeaders,
    String? authToken,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        ...?customHeaders,
      };

      http.Response response = await http
          .post(
            Uri.parse(pathApi),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: timeoutDuration));
     
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: ${e.toString()}');
    }
  }

  // Phương thức GET
  Future<http.Response> doGet(
    String pathApi, {
    Map<String, String>? queryParams,
    Map<String, String>? customHeaders,
    String? authToken,
  }) async {
    try {
      final headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        ...?customHeaders,
      };

      final uri = Uri.parse(pathApi).replace(
        queryParameters: queryParams,
      );

      final response = await http
          .get(
            uri,
            headers: headers,
          )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Phương thức PUT
  Future<http.Response> doPut(
    String pathApi,
    Map<String, dynamic> data, {
    Map<String, String>? customHeaders,
    String? authToken,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        ...?customHeaders,
      };

      final response = await http
          .put(
            Uri.parse(pathApi),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Phương thức DELETE
  Future<http.Response> doDelete(
    String pathApi, {
    Map<String, dynamic>? data,
    Map<String, String>? customHeaders,
    String? authToken,
  }) async {
    try {
      final headers = {
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        ...?customHeaders,
      };

      final response = await http
          .delete(
            Uri.parse(pathApi),
            headers: headers,
            body: data != null ? json.encode(data) : null,
          )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Phương thức PATCH
  Future<http.Response> doPatch(
    String pathApi,
    Map<String, dynamic> data, {
    Map<String, String>? customHeaders,
    String? authToken,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        ...?customHeaders,
      };

      final response = await http
          .patch(
            Uri.parse(pathApi),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Phương thức UPLOAD file (multipart request)
  Future<http.Response> doUpload(
    String pathApi,
    List<http.MultipartFile> files, {
    Map<String, String>? fields,
    Map<String, String>? customHeaders,
    String? authToken,
  }) async {
    try {
      final headers = {
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        ...?customHeaders,
      };

      var request = http.MultipartRequest('POST', Uri.parse(pathApi))
        ..headers.addAll(headers)
        ..files.addAll(files);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      final response = await request
          .send()
          .timeout(const Duration(seconds: timeoutDuration));

      final responseData = await http.Response.fromStream(response);
      return _handleResponse(responseData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Xử lý response từ server
  http.Response _handleResponse(http.Response response) {
    return response;
    // final statusCode = response.statusCode;
    // final responseData = json.decode(response.body);

    // if (statusCode >= 200 && statusCode < 300) {
    //   return responseData;
    // } else if (statusCode == 401) {
    //   throw Exception('Unauthorized: Phiên đăng nhập hết hạn');
    // } else if (statusCode == 403) {
    //   throw Exception('Forbidden: Không có quyền truy cập');
    // } else if (statusCode == 404) {
    //   throw Exception('Not Found: API không tồn tại');
    // } else if (statusCode >= 500) {
    //   throw Exception('Server Error: Lỗi hệ thống');
    // } else {
    //   throw Exception(
    //       'Error $statusCode: ${responseData['message'] ?? 'Lỗi không xác định'}');
    // }
  }

  // Xử lý lỗi từ network hoặc hệ thống
  Exception _handleError(dynamic error) {
    if (error is http.ClientException) {
      return Exception('Lỗi kết nối: ${error.message}');
    } else if (error is FormatException) {
      return Exception('Lỗi định dạng dữ liệu: ${error.message}');
    } else if (error is TimeoutException) {
      return Exception('Request timeout: Quá thời gian chờ phản hồi');
    } else {
      return Exception('Lỗi không xác định: $error');
    }
  }
}
