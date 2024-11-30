import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:szakdolgozat_mobil_driver_side/models/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState(userData: null, currentPos: null));

  setCurrentPosition() async {
    emit(state.copyWith(
      userData: null,
      currentPos: await Geolocator.getCurrentPosition(),
    ));
  }
}
