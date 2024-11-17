import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:szakdolgozat_mobil_driver_side/core/app_export.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/order/order_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_text_form_field.dart';

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
          width: SizeUtils.width,
          height: SizeUtils.height,
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
            if (state.isLoading) {
              return SizedBox(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotatePulse,
                  colors: [Colors.black],
                ),
              );
            }
            if (state.currentOrder != null) {
              return Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 1.v),
                child: Column(
                  children: [
                    SizedBox(height: 23.v),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5.v),
                          padding: EdgeInsets.symmetric(horizontal: 53.h),
                          child: Column(
                            children: [
                              _buildDataSection(context),
                              SizedBox(height: 22.v),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                children: [
                  Switch(
                      value: state.driverAvailable,
                      onChanged: (value) {
                        if(value){
                          context.read<OrderCubit>().setDriverAvailable();
                        }
                        _logger.d(value);
                      })
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildDataSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 1.h),
      padding: EdgeInsets.symmetric(vertical: 12.v),
      decoration: AppDecoration.fillPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.v),
          CustomTextFormField(
            hintText: "Jelenlegi foglalás",
            textInputAction: TextInputAction.done,
            contentPadding: EdgeInsets.symmetric(horizontal: 15.h),
            borderDecoration: TextFormFieldStyleHelper.underLineBlack,
            filled: false,
          ),
          SizedBox(height: 6.v),
          Padding(
            padding: EdgeInsets.only(left: 15.h),
            child: Row(
              children: [
                Text(
                  "utas neve:",
                  style: theme.textTheme.titleLarge,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    "Teszt Jani",
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
