import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.scryfall.com',
    headers: {
      'User-Agent': 'Scryfall Flutter App',
      'Accept': 'application/json',
    },
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        debugPrint('[Dio] Request failed: ${e.requestOptions.method} ${e.requestOptions.uri}');
        debugPrint('[Dio] Status: ${e.response?.statusCode} — ${e.message}');
        if (e.stackTrace != StackTrace.empty) {
          debugPrintStack(label: '[Dio] Stack trace', stackTrace: e.stackTrace);
        }
        handler.next(e);
      },
    ),
  );

  return dio;
});
