part of 'order_cubit.dart';

@immutable
class OrderState {}

class OrderWaiting extends OrderState {
  final bool driverActive;
  final String? errorMessage;

  OrderWaiting({required this.driverActive, this.errorMessage});
}

class OrderLoading extends OrderState {}

class OrderActive extends OrderState {
  final List<PointLatLng> currentRoute;
  final LatLng initialPos;
  final LatLng passengerPos;
  final double? passengerReviewAVG;

  OrderActive({
    required this.currentRoute,
    required this.initialPos,
    required this.passengerPos,
    required this.passengerReviewAVG,
  });
}
