import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../rest_client.dart';
import '../rest_client_response.dart';

const Duration connectionTimeout = Duration(seconds: 40);
const Duration receiveTimeout = Duration(seconds: 40);
const String baseUrl = '';

class AppClient extends _DioClient {
  AppClient({super.baseOptions, super.baseUrl}) {
    _dio.interceptors.addAll([
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: false,
        ),
    ]);
  }
}

class _DioClient implements RestClient {
  late final Dio _dio;
  final String? baseUrl;

  BaseOptions _defaultOptions() => BaseOptions(
    connectTimeout: connectionTimeout,
    receiveTimeout: receiveTimeout,
    headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
  );

  _DioClient({BaseOptions? baseOptions, this.baseUrl}) {
    _dio = Dio(baseOptions ?? _defaultOptions());
  }

  @override
  Future<RestClientResponseModel<T>> delete<T>(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConverter(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<RestClientResponseModel<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        data: data,
      );

      return _dioResponseConverter(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<RestClientResponseModel<T>> path<T>(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConverter(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<RestClientResponseModel<T>> post<T>(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConverter(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<RestClientResponseModel<T>> put<T>(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: {...?headers}),
      );

      return _dioResponseConverter(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<RestClientResponseModel<T>> request<T>(
    String url, {
    required String method,
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers, method: method),
      );

      return _dioResponseConverter(response);
    } on DioException {
      rethrow;
    }
  }

  Future<RestClientResponseModel<T>> _dioResponseConverter<T>(
    Response<dynamic> response,
  ) async => RestClientResponseModel<T>(
    data: response.data,
    statusCode: response.statusCode,
    statusMessage: response.statusMessage,
  );

  // Future<FormData?> _formData(
  //   List<AppMultipartFile>? appFormData,
  //   dynamic data,
  // ) async {
  //   if (appFormData?.isEmpty == true) return null;

  //   FormData? formData;
  //   if (appFormData?.isNotEmpty == true) {
  //     final Map<String, MultipartFile> fileMap = {
  //       for (var e in appFormData!)
  //         e.field: await MultipartFile.fromFile(
  //           e.path,
  //           filename: e.path.split('/').last,
  //           contentType: MediaType(e.type, e.path.mimeType),
  //         ),
  //     };

  //     formData = FormData.fromMap({...fileMap, ...data});
  //   }

  //   return formData;
  // }
}
