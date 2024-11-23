import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/main.dart';
import 'package:szakdolgozat_mobil_driver_side/models/Order.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';
import 'package:szakdolgozat_mobil_driver_side/services/secureStorage.dart';

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
  Order? currentOrder;

  OrderService() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      options.headers['cookie'] = 'token=${await getIt.get<SecureStorage>().getValue('token')};';
      handler.next(options);
    }));
    _dio.interceptors
        .add(InterceptorsWrapper(onResponse: (Response response, ResponseInterceptorHandler handler) async {
      if (response.statusCode == 401) {
        navigatorKey.currentState?.pushNamed(AppRoutes.driverRegistrationScreen);
      }
      handler.next(response);
    }));
  }

  Future<Order> getLatestForDriver(String driverId) async {
    final resp = await _dio.get(
      '/getLatestForDriver',
      data: {'driverId': driverId},
    );
    currentOrder = Order.fromJson(resp.data as Map<String, dynamic>);
    return currentOrder!;
  }

  Future<String> setDriverAvailable() async {
    final currentPos = await Geolocator.getCurrentPosition();
    final resp = await _dio.post('/setDriverAvailable', data: {
      'driverLat': currentPos.latitude,
      'driverLongit': currentPos.longitude,
    });
    return resp.data as String;
  }

  Future<bool> setDriverUnavailable() async {
    final resp = await _dio.post('/setDriverUnavailable');
    return resp.statusCode == 200;
  }
}
