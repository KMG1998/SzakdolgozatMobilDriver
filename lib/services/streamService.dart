import 'package:web_socket_channel/web_socket_channel.dart';

class StreamService{
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://10.0.2.2:8085'),
  );

  Stream getStream(){
    return _channel.stream;
  }

  WebSocketSink getSink(){
    return _channel.sink;
  }
}