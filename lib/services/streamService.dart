import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:szakdolgozat_mobil_driver_side/core/enums.dart';
import 'package:szakdolgozat_mobil_driver_side/models/StreamData.dart';

class StreamService {
  final StreamController<StreamData> _dataStream = StreamController();
  String _currentChannelId = '';
  final _socket = io(
  'http://10.0.2.2:8085',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false
      }
  );
  final _logger = Logger();

  StreamService(){
    _logger.d('create stream service');
    _socket.connect();
    _socket.onConnect((e) => _logger.d('websocket connect ok'));
    _socket.onError((e) {
      _logger.e('error: $e');
      if(!_socket.connected){
        _socket.connect();
      }
    });
    _socket.onDisconnect((e) => _logger.d('disconnect for $e'));
  }

  void connectToChannel(String channelId,void Function(StreamData,Position) onOrderInit) {
    _currentChannelId = channelId;
    _socket.on(channelId, (data) async {
      try {
        final streamData = StreamData.fromJson(jsonDecode(data));
        if(streamData.dataType == StreamDataType.orderInit){
          onOrderInit(streamData,await Geolocator.getCurrentPosition());
        }
      } catch (e) {
        _logger.e(e);
      }
    });
  }

  Stream getStream() {
    return _dataStream.stream;
  }

  String getCurrentChannelId() {
    return _currentChannelId;
  }

  void disconnectSocket() {
    try {
      _socket.off(_currentChannelId);
      _logger.d(_socket.listenersAny());
      _currentChannelId = '';
      _socket.disconnect();
    } catch (e) {
      _logger.e('disconnect error $e');
    }
  }
}
