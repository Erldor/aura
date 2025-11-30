import 'package:dio/dio.dart';

class ApiClient {
  // Измени в зависимости от платформы:
  // Android emulator -> http://10.0.2.2:5000
  // iOS simulator / desktop -> http://localhost:5000
  static const String baseUrl = "http://10.0.2.2:5000";

  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            contentType: "application/json",
          ),
        );

  // простой helper чтобы возвращать data или бросать
  Future<T> post<T>(String path, {dynamic data}) async {
    final res = await dio.post(path, data: data);
    return res.data as T;
  }

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    final res = await dio.get(path, queryParameters: queryParameters);
    return res.data as T;
  }
}