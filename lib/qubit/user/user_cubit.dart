import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/toast_wrapper.dart';
import 'package:szakdolgozat_mobil_driver_side/models/user.dart';
import 'package:szakdolgozat_mobil_driver_side/models/vehicle.dart';
import 'package:szakdolgozat_mobil_driver_side/services/user_service.dart';
import 'package:szakdolgozat_mobil_driver_side/services/vehicle_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserInit());

  final _logger = Logger();

  void getUserData() async {
    try {
      emit(UserLoading());
      final userData = await getIt.get<UserService>().getOwnData();
      emit(UserLoaded(userData: userData));
    } catch (e) {
      _logger.e(e);
      emit(UserError(errorMessage: 'Ismeretlen hiba'));
    }
  }

  void changeName(String newName) async {
    emit(UserLoading());
    final success = await getIt.get<UserService>().changeName(newName);
    if (success) {
      ToastWrapper.showSuccessToast(message: 'Sikeres mentés');
      emit(UserInit());
      return;
    }
    ToastWrapper.showErrorToast(message: 'Sikertelen mentés');
    emit(UserInit());
  }

  void getVehicleData() async {
    try {
      final userData = (state as UserLoaded).userData;
      emit(UserLoading());
      final vehicleData = await getIt.get<VehicleService>().getOwnVehicle();
      if(vehicleData == null){
       ToastWrapper.showErrorToast(message: 'Nincs hozzárendelt jármű');
      }
      emit(UserLoaded(userData: userData,vehicleData: vehicleData));
    }catch(e){
      _logger.e(e);
      emit(UserInit());
    }
  }
}
