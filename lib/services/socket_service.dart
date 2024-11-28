import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:szakdolgozat_mobil_driver_side/core/enums.dart';
import 'package:szakdolgozat_mobil_driver_side/models/StreamData.dart';

class SocketService {
  final StreamController<StreamData> _dataStream = StreamController();
  String _currentRoomId = '';
  final _socket = io('http://10.0.2.2:8085', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

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

  void connectToRoom({
    required String roomId,
    required String token,
    required void Function(StreamData, Position) onOrderInit,
    required void Function() onPassengerCancel,
  }) {
    _currentRoomId = roomId;
    _socket.io.options!['extraHeaders'] = {'token': token};
    _logger.d(_socket.io.options!['extraHeaders']);
    _socket.emit(SocketDataType.joinRoom.name, _currentRoomId);
    _logger.d(_socket.io.options!['extraHeaders']);
    _socket.on(SocketDataType.passengerCancel.name, (data) {
      try {
        onPassengerCancel();
        disconnectRoom();
      } catch (e) {
        _logger.e(e);
      }
    });
    _socket.on(SocketDataType.orderInit.name, (data) async {
      _logger.d(data);
      final streamData = StreamData.fromJson(jsonDecode(data));
      onOrderInit(streamData, await Geolocator.getCurrentPosition());
    });
  }

  Stream getStream() {
    return _dataStream.stream;
  }

  String getCurrentRoomId() {
    return _currentRoomId;
  }

  void emitData(StreamData data) {
    _socket.emit(data.dataType.name, jsonEncode({'roomId': _currentRoomId, 'streamData': data.data}));
  }

  void disconnectRoom() {
    try {
      _socket.emit(SocketDataType.leaveRoom.name, _currentRoomId);
      for (String listenerName in listenerNames) {
        _socket.off(listenerName);
      }
      _logger.d(_socket.listenersAny());
      _currentRoomId = '';
    } catch (e) {
      _logger.e('disconnect error $e');
    }
  }
}
