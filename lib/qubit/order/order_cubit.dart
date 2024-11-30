import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:szakdolgozat_mobil_driver_side/core/enums.dart';
import 'package:szakdolgozat_mobil_driver_side/core/popups/order_review_dialog.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/main.dart';
import 'package:szakdolgozat_mobil_driver_side/models/stream_data.dart';
import 'package:szakdolgozat_mobil_driver_side/models/order_init_data.dart';
import 'package:szakdolgozat_mobil_driver_side/models/review.dart';
import 'package:szakdolgozat_mobil_driver_side/services/orderService.dart';
import 'package:szakdolgozat_mobil_driver_side/services/secureStorage.dart';
import 'package:szakdolgozat_mobil_driver_side/services/socket_service.dart';

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
      final streamRoomId = await getIt.get<OrderService>().setDriverAvailable();
      if (streamRoomId.isNotEmpty) {
        _logger.d('room id: $streamRoomId');
        await getIt.get<SecureStorage>().setValue('roomId', streamRoomId);
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

  setDriverUnavailable() async {
    try {
      emit(OrderLoading());
      final success = await getIt.get<OrderService>().setDriverUnavailable();
      if (success) {
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

  refuseOrder() async {
    final socketService = getIt.get<SocketService>();
    await socketService.emitData(SocketDataType.driverCancel,StreamData(data: ''));
    socketService.disconnectRoom();
    emit(OrderWaiting(driverActive: false));
  }

  finishOrder() async {
    Review? orderReview;
    await showDialog(context: navigatorKey.currentContext!, barrierDismissible: false,builder: (ctx) => OrderReviewDialog()).then((value) {
      orderReview = value;
    });
    await getIt.get<SocketService>().emitData(SocketDataType.finishOrder,StreamData(data: jsonEncode(orderReview)));
    emit(OrderWaiting(driverActive: false));
  }

  _onOrderInit(streamData, currentPos) {
    final decodedData = OrderInitData.fromJson(jsonDecode(streamData.data));
    final currentRoute = PolylinePoints().decodePolyline(decodedData.routes.first.overviewPolyline!.points!);
    emit(
      OrderActive(
        currentRoute: currentRoute,
        passengerPos: decodedData.passengerPos,
        passengerReviewAVG: decodedData.passengerReviewAVG,
        initialPos: LatLng(
          currentPos.latitude,
          currentPos.longitude,
        ),
      ),
    );
  }

  _onOrderCancel() {
    emit(OrderWaiting(driverActive: false, errorMessage: 'Az utas visszautasította'));
  }
}
