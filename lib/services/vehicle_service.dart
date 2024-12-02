import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/models/user.dart';
import 'package:szakdolgozat_mobil_driver_side/models/vehicle.dart';

class VehicleService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8085/vehicle',
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

  VehicleService() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
      options.headers['cookie'] = 'token=${await getIt.get<FlutterSecureStorage>().read(key: 'token')};';
      handler.next(options);
    }));
  }

  Future<Vehicle?> getOwnVehicle() async {
    var resp = await _dio.get('/getOwnVehicle');
    return resp.data == null ? null : Vehicle.fromJson(resp.data);
  }
}
