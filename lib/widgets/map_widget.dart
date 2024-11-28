import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            stream: null,
            builder: (context, snapshot) {
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
                markers: {
                  Marker(
                      markerId: MarkerId('driver'),
                      position: LatLng(
                        widget.initialPos.latitude,
                        widget.initialPos.longitude,
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      infoWindow: InfoWindow(
                        title: 'Ön',
                      )),
                  Marker(
                      markerId: MarkerId('passenger'),
                      position: LatLng(
                        (state as OrderActive).passengerPos.latitude,
                        (state).passengerPos.longitude,
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                      infoWindow: InfoWindow(
                        title: 'Utas',
                      )),
                  Marker(
                      markerId: MarkerId('destination'),
                      position: LatLng(
                        (state).currentRoute.last.latitude,
                        (state).currentRoute.last.longitude,
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                      infoWindow: InfoWindow(
                        title: 'Úticél',
                      )),
                },
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
}
