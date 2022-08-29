import 'package:dio/dio.dart';

class FunfamDio {
  static final FunfamDio _instance = FunfamDio._privateConstructor();
  Dio? _http;

  factory FunfamDio() => _instance;

  FunfamDio._privateConstructor() {
    var options = BaseOptions(
      baseUrl: 'http://localhost:3000/',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );

    _http = Dio(options);
  }

  get client => _http!;
  dispose() {
    _http?.close();
  }
}
