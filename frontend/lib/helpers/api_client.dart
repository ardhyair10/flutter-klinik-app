import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiClient {
  // Langkah 1: Buat satu instance statis & privat untuk kelas ini
  static final ApiClient _instance = ApiClient._internal();

  // Langkah 2: Buat factory constructor sebagai 'pintu masuk' utama.
  // Setiap kali `ApiClient()` dipanggil, ia akan mengembalikan _instance yang sama.
  factory ApiClient() {
    return _instance;
  }

  late final Dio dio;
  final CookieJar _cookieJar = CookieJar();

  // Langkah 3: Jadikan constructor asli menjadi privat dengan menambahkan `._internal`
  // Ini mencegah pembuatan instance baru dari luar kelas.
  ApiClient._internal() {
    String baseUrl = dotenv.env['BASE_URL'] ?? "http://10.0.2.2:3000";
    String apiKey = dotenv.env['API_KEY'] ?? '';

    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'x-api-key': apiKey},
    );

    dio = Dio(baseOptions);

    // CookieManager sekarang akan menggunakan CookieJar yang sama untuk semua service
    dio.interceptors.add(CookieManager(_cookieJar));
  }

  // --- Metode untuk request API (tidak perlu diubah) ---

  Future<Response> get(String path) async {
    try {
      final response = await dio.get(
        path,
        options: Options(extra: {"withCredentials": true}),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        options: Options(extra: {"withCredentials": true}),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        options: Options(extra: {"withCredentials": true}),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await dio.delete(
        path,
        options: Options(extra: {"withCredentials": true}),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
