import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/models/Order.dart';
import 'package:szakdolgozat_mobil_driver_side/services/orderService.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState(isLoading: false, hasError: false, driverAvailable: false));
  final _logger = Logger();

  setDriverAvailable() async {
    try {
      const permission = Permission.location;
      while (await permission.isDenied) {
        await permission.request();
      }
      if (!await Geolocator.isLocationServiceEnabled() || await permission.isDenied) {
        emit(state.copyWith(hasError: true, errorMessage: 'Kérjük, kapcsolja be a GPS-t!'));
      }
      emit(state.copyWith(isLoading: true));
      final success = await getIt.get<OrderService>().setDriverAvailable();
      if (success) {
        emit(state.copyWith(isLoading: false, driverAvailable: true));
      } else {
        emit(state.copyWith(isLoading: false, driverAvailable: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, driverAvailable: false));
      _logger.e(e);
    }
  }

  setDriverUnavailable() async {
    try {
      emit(state.copyWith(isLoading: true));
      final success = await getIt.get<OrderService>().setDriverUnavailable();
      if (success) {
        emit(state.copyWith(isLoading: false, driverAvailable: false));
        return;
      }
      emit(state.copyWith(isLoading: false, driverAvailable: true));
    }catch(e){
      emit(state.copyWith(isLoading: false,driverAvailable: true,hasError: true,errorMessage: 'fuckup'));
    }
  }
}
