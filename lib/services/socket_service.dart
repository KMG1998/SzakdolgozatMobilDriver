import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:szakdolgozat_mobil_driver_side/core/enums.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/models/stream_data.dart';

class SocketService {
  final StreamController<StreamData> _dataStream = StreamController();
  static final _socket = io(
    'http://10.0.2.2:8085',
    OptionBuilder().disableAutoConnect().setTransports(['websocket']).build(),
  );
  final _backgroundService = FlutterBackgroundService();

  final List<String> listenerNames = [SocketDataType.orderInit.name, SocketDataType.passengerCancel.name];

  static final _logger = Logger();

  SocketService() {
    _logger.d('create stream service');
    _backgroundService.configure(
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
        androidConfiguration: AndroidConfiguration(
          autoStart: false,
          onStart: onStart,
          isForegroundMode: true,
          autoStartOnBoot: false,
        ));
    _logger.d('BS configured');
    _socket.connect();
    _socket.onConnect((e) {
      _logger.d('websocket connect ok');
    });
    _socket.onError((e) {
      _logger.e('error: $e');
      if (!_socket.connected) {
        _socket.connect();
      }
    });
    _socket.onDisconnect((e) {
      _logger.d('disconnect for $e');
      getIt.get<FlutterSecureStorage>().delete(key: 'roomId');
    });
  }

  void connectToRoom({
    required String roomId,
    required void Function(StreamData, Position) onOrderInit,
    required void Function() onPassengerCancel,
  }) {
    _socket.emit(SocketDataType.joinRoom.name, roomId);
    _socket.on(SocketDataType.passengerCancel.name, (data) {
      try {
        _logger.e('received passenger cancel');
        onPassengerCancel();
        stopBackgroundService();
        disconnectRoom();
      } catch (e) {
        _logger.e(e);
      }
    });
    _socket.on(SocketDataType.orderInit.name, (data) async {
      startBackgroundService();
      _logger.d('received orderInit');
      final streamData = StreamData.fromJson(jsonDecode(data));
      onOrderInit(streamData, await Geolocator.getCurrentPosition());
    });
  }

  Stream getStream() {
    return _dataStream.stream;
  }

  Future<void> emitData(SocketDataType emitType, String encodedData) async {
    final roomId = await getIt.get<FlutterSecureStorage>().read(key: 'roomId');
    final token = await getIt.get<FlutterSecureStorage>().read(key: 'token');
    _socket.emit(emitType.name, jsonEncode({'userToken': token, 'roomId': roomId, 'data': encodedData}));
  }

  void disconnectRoom() async {
    try {
      final roomId = await getIt.get<FlutterSecureStorage>().read(key: 'roomId');
      _socket.emit(SocketDataType.leaveRoom.name, roomId);
      for (String listenerName in listenerNames) {
        _socket.off(listenerName);
      }
      getIt.get<FlutterSecureStorage>().delete(key: 'roomId');
    } catch (e) {
      _logger.e('disconnect error $e');
    }
  }

  void startBackgroundService() async {
    await _backgroundService.startService();
  }

  void stopBackgroundService() {
    _backgroundService.invoke('stop');
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized;
    WidgetsFlutterBinding.ensureInitialized();
    initServiceLocator();
    service.on('stop').listen((event) {
      service.stopSelf();
    });
    _socket.connect();
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _emitPosition();
    });
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  static Future<void> _emitPosition() async {
    final roomId = await getIt.get<FlutterSecureStorage>().read(key: 'roomId');
    final token = await getIt.get<FlutterSecureStorage>().read(key: 'token');

    final currentLocation = await Geolocator.getCurrentPosition();
    _socket.emit(
        SocketDataType.driverGeoData.name,
        jsonEncode({
          'userToken': token,
          'roomId': roomId,
          'data': LatLng(currentLocation.latitude, currentLocation.longitude)
        }));
  }
}
