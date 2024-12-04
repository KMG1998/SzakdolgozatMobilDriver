import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/main.dart';
import 'package:szakdolgozat_mobil_driver_side/models/order.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';

class OrderService {
  final _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8085/order',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
      'Access-Control-Request-Headers': 'Origin',
      'Origin': 'mobileApp',
    },
    responseType: ResponseType.json,
  ));

  final _logger = Logger();


  OrderService() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      options.headers['cookie'] = 'token=${await getIt.get<FlutterSecureStorage>().read(key:'token')};';
      handler.next(options);
    }));
    _dio.interceptors
        .add(InterceptorsWrapper(onResponse: (Response response, ResponseInterceptorHandler handler) {
      if (response.statusCode == 401) {
        navigatorKey.currentState?.pushNamed(AppRoutes.loginScreen);
        return;
      }
      handler.next(response);
    }));
  }

  Future<String> setDriverAvailable() async {
    _logger.d('sent available request');
    final currentPos = await Geolocator.getCurrentPosition();
    final resp = await _dio.post('/setDriverAvailable', data: {
      'driverLat': currentPos.latitude,
      'driverLongit': currentPos.longitude,
    });
    _logger.d('received available response');
    return resp.data as String;
  }

  Future<bool> setDriverUnavailable() async {
    final resp = await _dio.post('/setDriverUnavailable', data: {
      'webSocketRoomId': await getIt.get<FlutterSecureStorage>().read(key:'roomId'),
    });
    return resp.statusCode == 200;
  }

  Future<List<Order>?> getHistory() async{
    final resp = await _dio.get('/getDriverHistory');
    if(resp.statusCode == 200){
      return (jsonDecode(resp.data)["history"] as List).map((e) => Order.fromJson(e)).toList();
    }
    return null;
  }
}
