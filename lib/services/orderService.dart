import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/main.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';
import 'package:szakdolgozat_mobil_driver_side/services/secureStorage.dart';
import 'package:szakdolgozat_mobil_driver_side/services/socket_service.dart';

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

  Future<String> setDriverAvailable() async {
    final currentPos = await Geolocator.getCurrentPosition();
    final resp = await _dio.post('/setDriverAvailable', data: {
      'driverLat': currentPos.latitude,
      'driverLongit': currentPos.longitude,
    });
    return resp.data as String;
  }

  Future<bool> setDriverUnavailable() async {
    final resp = await _dio.post('/setDriverUnavailable', data: {
      'webSocketChannelId': getIt.get<StreamService>().getCurrentRoomId(),
    });
    return resp.statusCode == 200;
  }
}
