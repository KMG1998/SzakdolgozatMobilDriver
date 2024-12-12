import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:szakdolgozat_mobil_driver_side/core/popups/change_password_dialog.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/toast_wrapper.dart';
import 'package:szakdolgozat_mobil_driver_side/generated/assets.gen.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/auth/auth_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/user/user_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/app_decoration.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/custom_button_style.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_nav_bar.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';

class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({super.key});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                if (state is UserInit) {
                  context.read<UserCubit>().getUserData();
                }
                if (state is UserLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 550.w,
                          height: 150.h,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusStyle.roundedBorder20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _profileHeadline(
                                email: state.userData.email,
                                name: state.userData.name,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        _createActionButton(
                            text: 'jelszó megváltoztatása',
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) => ChangePasswordDialog());
                            }),
                        _createActionButton(
                            text: 'Jármű adatok',
                            onPressed: () {
                              context.read<UserCubit>().getVehicleData();
                              Navigator.pushNamed(context, AppRoutes.vehicleDataPage);
                            }),
                        _createActionButton(
                            text: 'értékelések megtekintése',
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.receivedReviews);
                            }),
                        SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {
                              context.read<AuthCubit>().logOut();
                            },
                            icon: Assets.lib.assets.images.logOut.svg(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Kijelentkezés',
                          style: theme.textTheme.titleLarge,
                        )
                      ],
                    ),
                  );
                }
                if (state is UserError) {
                  ToastWrapper.showErrorToast(message: state.errorMessage);
                  return SizedBox();
                }
                return _loadingIndicator;
              },
            ),
          ),
          bottomNavigationBar: CustomNavBar(activeNum: 2),
        ),
      ),
    );
  }

  final Widget _loadingIndicator = Center(
    child: Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: LoadingIndicator(
          indicatorType: Indicator.ballClipRotatePulse,
          colors: [Colors.black],
        ),
      ),
    ),
  );

  Widget _profileHeadline({required String name, required String email}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Profil adatok',
                style: theme.textTheme.headlineLarge,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Column(
          children: [
            Text(
              'e-mail: $email',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            Text(
              'név: $name',
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _createActionButton({required String text, required void Function() onPressed}) {
    return CustomOutlinedButton(
      text: text,
      buttonStyle: CustomButtonStyles.outlineBlack,
      margin: EdgeInsets.symmetric(vertical: 10),
      buttonTextStyle: theme.textTheme.headlineLarge!.copyWith(
        decoration: TextDecoration.underline,
      ),
      onPressed: onPressed,
    );
  }
}
