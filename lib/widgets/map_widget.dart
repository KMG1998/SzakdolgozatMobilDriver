import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/order/order_cubit.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialPos;

  const MapWidget({super.key, required this.initialPos});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return SizedBox(
          width: 500.w,
          height: 500.h,
          child: StreamBuilder(
            stream: Geolocator.getPositionStream(),
            builder: (context, snapshot) {
              Set<Marker> markers = _buildMarkers(state as OrderActive);
              if(snapshot.data?.longitude != null){
                markers.removeWhere((marker) => marker.markerId == MarkerId('driver'));
                markers.add(
                  Marker(
                    markerId: MarkerId('driver'),
                    position: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                    infoWindow: InfoWindow(
                      title: 'Ön',
                    ),
                  ),
                );
              }
              return GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.initialPos.latitude,
                      widget.initialPos.longitude,
                    ),
                    zoom: 12),
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: markers,
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('direction_polyline'),
                    color: Theme.of(context).colorScheme.primary,
                    width: 5,
                    points: (state).currentRoute.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                  )
                },
              );
            },
          ),
        );
      },
    );
  }

  Set<Marker> _buildMarkers(OrderActive state) {
    final markers = {
      Marker(
        markerId: MarkerId('destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(
          (state).currentRoute.last.latitude,
          (state).currentRoute.last.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Úticél',
        ),
      ),
    };
    if (!state.passengerPickedUp) {
      markers.add(
        Marker(
          markerId: MarkerId('passenger'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(
            (state).passengerPos.latitude,
            (state).passengerPos.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Utas',
          ),
        ),
      );
    }
    return markers;
  }
}
