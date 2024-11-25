import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/gen/assets.gen.dart';
import 'package:szakdolgozat_mobil_driver_side/models/Order.dart';
import 'package:szakdolgozat_mobil_driver_side/services/orderService.dart';
import 'package:szakdolgozat_mobil_driver_side/services/streamService.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderWaiting(driverActive: false));
  final _logger = Logger();

  setDriverAvailable() async {
    try {
      const permission = Permission.location;
      while (await permission.isDenied) {
        await permission.request();
      }
      if (!await Geolocator.isLocationServiceEnabled() || await permission.isDenied) {
        emit(OrderWaiting(driverActive: false, errorMessage: 'Kérjük, engedélyezze és kapcsolja be a GPS-t!'));
        return;
      }
      emit(OrderLoading());
      getIt.get<StreamService>().getCurrentChannelId();
      final streamChannelId = await getIt.get<OrderService>().setDriverAvailable();
      if (streamChannelId.isNotEmpty) {
        getIt.get<StreamService>().connectToChannel(streamChannelId, (streamData, currentPos) {
          final decodedData = jsonDecode(streamData.data);
          final currentRoute = PolylinePoints().decodePolyline(decodedData[0]['overview_polyline']['points']);
          emit(
            OrderActive(
                currentRoute: currentRoute,
                initialPos: LatLng(
                  currentPos.latitude,
                  currentPos.longitude,
                ),
            ),
          );
        });
        emit(OrderWaiting(driverActive: true));
        Fluttertoast.showToast(msg: 'Sikeres aktiválás');
        return;
      }
      emit(OrderWaiting(driverActive: false, errorMessage: 'Ismeretlen hiba'));
    } catch (e) {
      emit(OrderWaiting(driverActive: false, errorMessage: 'Sikertelen aktiválás'));
      _logger.e(e);
    }
  }

  setDriverUnavailable() async {
    try {
      emit(OrderLoading());
      final success = await getIt.get<OrderService>().setDriverUnavailable();
      if (success) {
        getIt.get<StreamService>().disconnectSocket();
        emit(OrderWaiting(driverActive: false));
        return;
      }
      emit(OrderWaiting(driverActive: true, errorMessage: 'Ismeretlen hiba'));
    } catch (e) {
      _logger.e(e);
      emit(OrderWaiting(driverActive: true, errorMessage: 'Sikertelen deaktiválás'));
    }
  }
}
