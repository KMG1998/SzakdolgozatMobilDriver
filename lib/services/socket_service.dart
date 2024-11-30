import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:szakdolgozat_mobil_driver_side/core/enums.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/service_locator.dart';
import 'package:szakdolgozat_mobil_driver_side/models/StreamData.dart';
import 'package:szakdolgozat_mobil_driver_side/services/secureStorage.dart';

class SocketService {
  final StreamController<StreamData> _dataStream = StreamController();
  final _socket = io(
    'http://10.0.2.2:8085',
    OptionBuilder().disableAutoConnect().setTransports(['websocket']).build(),
  );

  final List<String> listenerNames = [SocketDataType.orderInit.name, SocketDataType.passengerCancel.name];

  final _logger = Logger();

  SocketService() {
    _logger.d('create stream service');
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
    _socket.onDisconnect((e) => _logger.d('disconnect for $e'));
  }

  void connectToRoom ({
    required String roomId,
    required void Function(StreamData, Position) onOrderInit,
    required void Function() onPassengerCancel,
  }) {
    _socket.emit(SocketDataType.joinRoom.name, roomId);
    _socket.on(SocketDataType.passengerCancel.name, (data) {
      try {
        onPassengerCancel();
        _logger.d('passenger cancelled');
        disconnectRoom();
      } catch (e) {
        _logger.e(e);
      }
    });
    _socket.on(SocketDataType.orderInit.name, (data) async {
      final streamData = StreamData.fromJson(jsonDecode(data));
      onOrderInit(streamData, await Geolocator.getCurrentPosition());
    });
  }

  Stream getStream() {
    return _dataStream.stream;
  }

  void emitData(SocketDataType emitType,StreamData data) async {
    final roomId = await getIt.get<SecureStorage>().getValue('roomId');
    final token = await getIt.get<SecureStorage>().getValue('token');
    _socket.emit(emitType.name, jsonEncode({'token': token, 'roomId': roomId, 'streamData': data.data}));
  }

  void disconnectRoom() async {
    try {
      final roomId = await getIt.get<SecureStorage>().getValue('roomId');
      _socket.emit(SocketDataType.leaveRoom.name, roomId);
      for (String listenerName in listenerNames) {
        _socket.off(listenerName);
      }
      getIt.get<SecureStorage>().deleteValue('roomId');
    } catch (e) {
      _logger.e('disconnect error $e');
    }
  }
}
