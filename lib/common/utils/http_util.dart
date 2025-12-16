import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:wal/common/values/constant.dart';
import '../../global.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConstants.SERVER_API_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {},
      contentType: "application/x-www-form-urlencoded", // CHANGED from JSON
      responseType: ResponseType.json,
    );
    dio = Dio(options);

    // Handle SSL certificate issues (for development only)
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };

    // Add interceptors for logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('REQUEST DATA: ${options.data}');
          print('CONTENT TYPE: ${options.contentType}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> post(
    String path, {
    dynamic mydata,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    // Add authorization header if token exists
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    // Convert JSON data to form data if needed
    dynamic requestData = mydata;
    if (mydata is Map<String, dynamic>) {
      requestData = FormData.fromMap(mydata); // CONVERT TO FORM DATA
    }

    try {
      var response = await dio.post(
        path,
        data: requestData, // Use converted form data
        queryParameters: queryParameters,
        options: requestOptions,
      );

      // Handle string JSON responses
      if (response.data is String) {
        try {
          return jsonDecode(response.data as String);
        } catch (e) {
          print('⚠️ Response is string but not JSON: ${response.data}');
          return response.data;
        }
      }

      return response.data;
    } on DioException catch (e) {
      // Handle specific error cases
      if (e.response != null) {
        // Also handle string responses in errors
        if (e.response!.data is String) {
          try {
            return jsonDecode(e.response!.data as String);
          } catch (parseError) {
            return e.response!.data;
          }
        }
        return e.response!.data;
      } else {
        rethrow;
      }
    }
  }

  // Keep getAuthorizationHeader() and get() method the same...
  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    var accessToken = Global.storageService.getUserToken();
    if (accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};

    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    try {
      var response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: requestOptions,
      );

      // Handle string JSON responses for GET requests too
      if (response.data is String) {
        try {
          return jsonDecode(response.data as String);
        } catch (e) {
          print('⚠️ GET Response is string but not JSON: ${response.data}');
          return response.data;
        }
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle string responses in errors for GET
        if (e.response!.data is String) {
          try {
            return jsonDecode(e.response!.data as String);
          } catch (parseError) {
            return e.response!.data;
          }
        }
        return e.response!.data;
      } else {
        rethrow;
      }
    }
  }
}
