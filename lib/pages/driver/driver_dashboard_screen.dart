import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:szakdolgozat_mobil_driver_side/core/app_export.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/order/order_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/services/socket_service.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_text_form_field.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/map_widget.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [
                theme.colorScheme.primaryContainer,
                appTheme.blue100,
                theme.colorScheme.onSecondaryContainer,
              ],
            ),
          ),
          child: BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
            if (state is OrderWaiting && state.errorMessage != null) {
              Fluttertoast.showToast(
                  msg: state.errorMessage ?? 'Ismeretlen hiba',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            if (state is OrderWaiting) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Jöhetnek a foglalások?',
                      style: theme.textTheme.headlineLarge,
                    ),
                    SizedBox(height: 3.h),
                    Switch(
                        value: state.driverActive,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white,
                        inactiveThumbColor: Colors.red,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          if (value) {
                            context.read<OrderCubit>().setDriverAvailable();
                            return;
                          }
                          context.read<OrderCubit>().setDriverUnavailable();
                        })
                  ],
                ),
              );
            }
            if (state is OrderActive) {
              return Column(
                children: [
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: Colors.white,
                      child: Text(
                        'Utas értékelés átlaga: ${state.passengerReviewAVG?.toStringAsFixed(2) ?? 'nincs'}',
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: 20),
                  MapWidget(initialPos: state.initialPos),
                  SizedBox(height: 20),
                  CustomOutlinedButton(
                    text: 'Elutasít',
                    buttonStyle: CustomButtonStyles.outlineRed,
                    onPressed: () {
                      _logger.d('clicked');
                      context.read<OrderCubit>().refuseOrder();
                    },
                  ),
                  SizedBox(height: 20),
                  CustomOutlinedButton(
                    text: 'Fuvar lezárása',
                    buttonStyle: CustomButtonStyles.outlineGreen,
                    onPressed: () {
                      context.read<OrderCubit>().finishOrder();
                    },
                  )
                ],
              );
            }
            return SizedBox(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotatePulse,
                colors: [Colors.black],
              ),
            );
          }),
        ),
      ),
    );
  }
}
