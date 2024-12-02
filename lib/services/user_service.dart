import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:szakdolgozat_mobil_driver_side/models/user.dart';

import '../core/utils/service_locator.dart';

class UserService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8085/user',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Access-Control-Request-Headers': 'Origin',
        'Origin': 'mobileApp',
      },
    ),
  );

  final _logger = Logger();

  UserService() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      options.headers['cookie'] = 'token=${await getIt.get<FlutterSecureStorage>().read(key: 'token')};';
      handler.next(options);
    }));
  }

  Future<User> getOwnData() async {
    final resp = await _dio.get(
      '/getOwnData',
    );
    return User.fromJson(resp.data);
  }

  Future<bool> logUserIn(String email, String password) async {
    var resp = await _dio.post(
      '/signInDriver',
      data: {
        'email': email,
        'password': password,
      },
    );
    final token = resp.headers['set-cookie']![0].split(';')[0].split('=')[1];
    await getIt.get<FlutterSecureStorage>().write(key: 'token', value: token);
    return resp.statusCode == 200;
  }

  Future<bool> resetPassword(String email) async {
    final resp = await _dio.post(
      '/resetPassword',
      data: {
        'userEmail': email,
      },
    );
    if (resp.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> checkToken() async {
    try {
      final resp = await _dio.get(
        '/checkToken',
      );
      return resp.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      final resp = await _dio.post(
        '/logOut',
      );
      return resp.statusCode == 200;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      final resp = await _dio.post(
        '/changePassword',
        data: {
          'currentPass': currentPassword,
          'newPass': newPassword,
        },
      );
      return resp.statusCode == 200;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  Future<bool> changeName(String newName) async {
    try {
      final resp = await _dio.post(
        '/changeName',
        data: {
          'newName': newName,
        },
      );
      return resp.statusCode == 200;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }
}
