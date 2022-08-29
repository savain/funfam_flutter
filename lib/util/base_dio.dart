import 'package:dio/dio.dart';

class BaseDio {
  static final BaseDio _instance = BaseDio._internal();
  Dio? _http;

  factory BaseDio() => _instance;

  BaseDio._internal() {
    _http = Dio();
    _http?.options.baseUrl = 'http://15.164.151.240';
  }

  get client => _http;
  dispose() {
    _http?.close();
  }
}
