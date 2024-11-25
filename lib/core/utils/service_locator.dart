import 'package:get_it/get_it.dart';
import 'package:szakdolgozat_mobil_driver_side/services/orderService.dart';
import 'package:szakdolgozat_mobil_driver_side/services/secureStorage.dart';
import 'package:szakdolgozat_mobil_driver_side/services/streamService.dart';
import 'package:szakdolgozat_mobil_driver_side/services/userService.dart';
import 'package:szakdolgozat_mobil_driver_side/services/vehicleToUserService.dart';

final getIt = GetIt.instance;

void initServiceLocator() {
  getIt.registerLazySingleton(() => OrderService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => VehicleToUserService());
  getIt.registerLazySingleton(() => SecureStorage());
  getIt.registerLazySingleton<StreamService>(() => StreamService());
}
