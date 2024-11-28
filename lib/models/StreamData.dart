import 'package:logger/logger.dart';
import 'package:szakdolgozat_mobil_driver_side/core/enums.dart';

class StreamData {
  final SocketDataType dataType;
  final String data;

  StreamData({required this.dataType, required this.data});

  StreamData.fromJson(Map<String, dynamic> json)
      : dataType = SocketDataType.values.firstWhere((dataType) {
          return dataType.name.toString() == json['dataType'];
        }),
        data = json['data'] as String;

  Map<String, dynamic> toJson() => {
        'dataType': dataType,
        'data': data,
      };
}
