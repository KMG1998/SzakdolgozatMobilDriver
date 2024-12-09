part of 'order_cubit.dart';

@immutable
class OrderState {}

class OrderInit extends OrderState {}

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
  final int price;
  final bool passengerPickedUp;
  final double? passengerReviewAVG;

  OrderActive(
      {required this.currentRoute,
      required this.initialPos,
      required this.passengerPos,
      required this.passengerReviewAVG,
      required this.passengerPickedUp,
      required this.price});

  OrderActive copyWith({
    List<PointLatLng>? currentRoute,
    LatLng? initialPos,
    LatLng? passengerPos,
    bool? passengerPickedUp,
    double? passengerReviewAVG,
    int? price,
  }) {
    return OrderActive(
      currentRoute: currentRoute ?? this.currentRoute,
      initialPos: initialPos ?? this.initialPos,
      passengerPos: passengerPos ?? this.passengerPos,
      passengerReviewAVG: passengerReviewAVG ?? this.passengerReviewAVG,
      passengerPickedUp: passengerPickedUp ?? this.passengerPickedUp,
      price: price ?? this.price,
    );
  }
}
