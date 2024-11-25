import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:szakdolgozat_mobil_driver_side/core/app_export.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/order/order_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/services/streamService.dart';
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
                  MapWidget(initialPos: state.initialPos),
                  CustomOutlinedButton(
                    text: 'off',
                    onPressed: () {
                      _logger.d('clicked');
                      context.read<OrderCubit>().setDriverUnavailable();
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
            /*if (state.currentOrder != null) {
              return Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 1.w),
                child: Column(
                  children: [
                    SizedBox(height: 23.w),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5.w),
                          padding: EdgeInsets.symmetric(horizontal: 53.h),
                          child: Column(
                            children: [
                              _buildDataSection(context),
                              SizedBox(height: 22.w),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }*/
          }),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildDataSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 1.h),
      padding: EdgeInsets.symmetric(vertical: 12.w),
      decoration: AppDecoration.fillPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.w),
          CustomTextFormField(
            hintText: "Jelenlegi foglalás",
            textInputAction: TextInputAction.done,
            contentPadding: EdgeInsets.symmetric(horizontal: 15.h),
            borderDecoration: TextFormFieldStyleHelper.underLineBlack,
            filled: false,
          ),
          SizedBox(height: 6.w),
        ],
      ),
    );
  }
}
