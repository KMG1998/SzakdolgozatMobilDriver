import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:szakdolgozat_mobil_driver_side/services/order_service.dart';
import 'package:szakdolgozat_mobil_driver_side/services/review_service.dart';
import 'package:szakdolgozat_mobil_driver_side/services/socket_service.dart';
import 'package:szakdolgozat_mobil_driver_side/services/user_service.dart';
import 'package:szakdolgozat_mobil_driver_side/services/vehicle_service.dart';

final getIt = GetIt.instance;

void initServiceLocator() {
  getIt.registerLazySingleton(() => OrderService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => VehicleService());
  getIt.registerLazySingleton<SocketService>(() => SocketService());
  getIt.registerLazySingleton<ReviewService>(() => ReviewService());
  getIt.registerLazySingleton(
        () => FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );
}
