import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderInitData {
  final double? passengerReviewAVG;
  final LatLng passengerPos;
  final List<DirectionsRoute> routes;

  OrderInitData({required this.passengerPos, required this.routes, required this.passengerReviewAVG});

  OrderInitData.fromJson(Map<String, dynamic> json)
      : routes = (json['routes'] as List).map((e) => DirectionsRoute.fromMap(e)).toList(),
        passengerReviewAVG = json['passengerReviewAVG'] is int
            ? (json['passengerReviewAVG'] as int).toDouble()
            : json['passengerReviewAVG'] as double?,
        passengerPos = LatLng(json['passengerPos']['latitude'], json['passengerPos']['longitude']);
}
