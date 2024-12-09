import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:szakdolgozat_mobil_driver_side/core/enums.dart';
import 'package:szakdolgozat_mobil_driver_side/core/popups/background_location_permission_dialog.dart';
import 'package:szakdolgozat_mobil_driver_side/core/popups/order_review_dialog.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/main.dart';
import 'package:szakdolgozat_mobil_driver_side/models/order_review.dart';
import 'package:szakdolgozat_mobil_driver_side/models/stream_data.dart';
import 'package:szakdolgozat_mobil_driver_side/models/order_init_data.dart';
import 'package:szakdolgozat_mobil_driver_side/services/order_service.dart';
import 'package:szakdolgozat_mobil_driver_side/services/socket_service.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInit());
  final _logger = Logger();

  initState() async {
    emit(OrderLoading());
    final secureStorage = getIt.get<FlutterSecureStorage>();
    final roomId = await secureStorage.read(key: 'roomId');
    if (roomId == null) {
      emit(OrderWaiting(driverActive: false));
      return;
    }
    final socketService = getIt.get<SocketService>();
    socketService.connectToRoom(
      roomId: roomId,
      onOrderInit: _onOrderInit,
      onPassengerCancel: _onOrderCancel,
    );
    final orderDataString = await secureStorage.read(key: 'orderData');
    if (orderDataString == null) {
      emit(OrderWaiting(driverActive: true));
      return;
    }
    final orderData = OrderInitData.fromJson(jsonDecode(orderDataString));
    final currentRoute = PolylinePoints().decodePolyline(orderData.routes.first.overviewPolyline!.points!);
    final currentPos = await Geolocator.getCurrentPosition();
    emit(
      OrderActive(
        currentRoute: currentRoute,
        passengerPos: orderData.passengerPos,
        passengerReviewAVG: orderData.passengerReviewAVG,
        passengerPickedUp: false,
        price: orderData.price,
        initialPos: LatLng(
          currentPos.latitude,
          currentPos.longitude,
        ),
      ),
    );
    return;
  }

  void setDriverAvailable() async {
    try {
      final permissionsGranted = await _checkPermissions();
      if (!await Geolocator.isLocationServiceEnabled() || !permissionsGranted) {
        emit(OrderWaiting(
            driverActive: false, errorMessage: 'Kérjük, engedélyezze a kért erőforrásokat és kapcsolja be a GPS-t!'));
        return;
      }
      emit(OrderLoading());
      final streamRoomId = await getIt.get<OrderService>().setDriverAvailable();
      if (streamRoomId.isNotEmpty) {
        await getIt.get<FlutterSecureStorage>().write(key: 'roomId', value: streamRoomId);
        getIt.get<SocketService>().connectToRoom(
              roomId: streamRoomId,
              onOrderInit: _onOrderInit,
              onPassengerCancel: _onOrderCancel,
            );
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

  void setDriverUnavailable() async {
    try {
      emit(OrderLoading());
      final success = await getIt.get<OrderService>().setDriverUnavailable();
      if (success) {
        await getIt.get<FlutterSecureStorage>().delete(key: 'roomId');
        getIt.get<SocketService>().disconnectRoom();
        emit(OrderWaiting(driverActive: false));
        return;
      }
      emit(OrderWaiting(driverActive: true, errorMessage: 'Ismeretlen hiba'));
    } catch (e) {
      _logger.e(e);
      emit(OrderWaiting(driverActive: true, errorMessage: 'Sikertelen deaktiválás'));
    }
  }

  void refuseOrder() async {
    final socketService = getIt.get<SocketService>();
    await socketService.emitData(SocketDataType.driverCancel, '');
    socketService.disconnectRoom();
    socketService.stopBackgroundService();
    emit(OrderWaiting(driverActive: false));
  }

  void pickUpPassenger() async {
    await getIt.get<SocketService>().emitData(SocketDataType.pickUpPassenger, '');
    emit((state as OrderActive).copyWith(passengerPickedUp: true));
  }

  void finishOrder() async {
    OrderReview? orderReview;
    await showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (ctx) => OrderReviewDialog()).then((value) {
      orderReview = value;
    });
    final socketService = getIt.get<SocketService>();
    await socketService.emitData(SocketDataType.finishOrder, jsonEncode(orderReview));
    socketService.disconnectRoom();
    socketService.stopBackgroundService();
    emit(OrderWaiting(driverActive: false));
  }

  _onOrderInit(streamData, currentPos) async {
    await getIt.get<FlutterSecureStorage>().write(key: 'orderData', value: streamData.data);
    final decodedData = OrderInitData.fromJson(jsonDecode(streamData.data));
    final currentRoute = PolylinePoints().decodePolyline(decodedData.routes.first.overviewPolyline!.points!);
    emit(
      OrderActive(
        currentRoute: currentRoute,
        passengerPos: decodedData.passengerPos,
        passengerReviewAVG: decodedData.passengerReviewAVG,
        passengerPickedUp: false,
        price: decodedData.price,
        initialPos: LatLng(
          currentPos.latitude,
          currentPos.longitude,
        ),
      ),
    );
  }

  _onOrderCancel() {
    _logger.e('In order cancel');
    emit(OrderWaiting(driverActive: false, errorMessage: 'Az utas visszautasította'));
  }

  Future<bool> _checkPermissions() async {
    final permissions = [Permission.location, Permission.locationAlways];
    for (Permission permission in permissions) {
      while (await permission.isDenied) {
        if (permission == Permission.locationAlways) {
          await showDialog(
              context: navigatorKey.currentContext!, builder: (ctx) => BackgroundLocationPermissionDialog());
        }
        await permission.request();
      }
    }
    final isGranted = [await Permission.location.isGranted, await Permission.locationAlways.isGranted];
    return isGranted.every((permissionGranted) => permissionGranted);
  }
}
