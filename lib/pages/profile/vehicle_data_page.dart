import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/user/user_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/app_decoration.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';

class VehicleDataPage extends StatefulWidget {
  const VehicleDataPage({super.key});

  @override
  State<VehicleDataPage> createState() => _VehicleDataPageState();
}

class _VehicleDataPageState extends State<VehicleDataPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (a,b)=>{},
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.5, 0),
                end: const Alignment(0.5, 1),
                colors: [
                  theme.colorScheme.primaryContainer,
                  appTheme.blue100,
                  theme.colorScheme.onSecondaryContainer,
                ],
              ),
            ),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _createItem('Rendszám: ${state.vehicleData?.plateNumber}'),
                      _createItem('Típus: ${state.vehicleData?.type}'),
                      _createItem('Szín: ${state.vehicleData?.color}'),
                      _createItem('Ülések száma: ${state.vehicleData?.seats.toString()}'),
                    ],
                  );
                }
                if(state is UserLoading){
                  return const SizedBox(
                    width: 50,
                    height: 50,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballClipRotatePulse,
                      colors: [Colors.black],
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Sikertelen betöltés!',
                    style: theme.textTheme.headlineLarge!.copyWith(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _createItem(String text) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2),
        borderRadius: BorderRadiusStyle.circleBorder15,
      ),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
