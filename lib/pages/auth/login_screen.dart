import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:szakdolgozat_mobil_driver_side/core/app_export.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/login/login_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_text_form_field.dart';

import '../../generated/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              begin: const Alignment(0.5, 0),
              end: const Alignment(0.5, 1),
              colors: [
                theme.colorScheme.primaryContainer,
                appTheme.blue100,
                theme.colorScheme.onSecondaryContainer,
              ],
            ),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(height: 23.w),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 164.w),
                      child: Form(
                        key: context.read<LoginCubit>().formKey,
                        child: Column(
                          children: [
                            CustomImageView(
                              imagePath: Assets.imagesImgMagantaxiLogo1,
                              height: 319.h,
                              width: 319.w,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "E-mail",
                              style: theme.textTheme.headlineLarge,
                            ),
                            SizedBox(height: 7.h),
                            CustomTextFormField(
                              width: 500.w,
                              controller: context.read<LoginCubit>().emailInputController,
                              validator: (email) => Validators.emailValidator(email),
                              focusNode: context.read<LoginCubit>().emailFocus,
                              autofocus: false,
                            ),
                            SizedBox(height: 31.h),
                            Text(
                              "Jelszó",
                              style: theme.textTheme.headlineLarge,
                            ),
                            SizedBox(height: 7.h),
                            CustomTextFormField(
                              width: 500.w,
                              controller: context.read<LoginCubit>().passwordInputController,
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              autoCorrect: false,
                              enableSuggestions: false,
                              focusNode: context.read<LoginCubit>().passwordFocus,
                              validator: (password) => Validators.passwordValidator(password),
                              autofocus: false,
                            ),
                            SizedBox(height: 32.h),
                            _loginButton(),
                            SizedBox(height: 52.h),
                            Text(
                              "Elfelejtett jelszó",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(height: 56.w),
                            _registerButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registerButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.driverRegistrationScreen);
      },
      child: Text(
        "Regisztráció",
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  _loginButton() {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.hasError) {
          Fluttertoast.showToast(
              msg: "Invalid email or password!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }else if(!state.isLoading && !state.hasError){
          Navigator.pushNamed(context, AppRoutes.driverDashboardScreen);
        }
      },
      builder: (context, state) {
        if (!state.isLoading) {
          return CustomOutlinedButton(
            height: 28,
            width: 269,
            text: "Belépés",
            buttonStyle: CustomButtonStyles.outlineBlack,
            buttonTextStyle: theme.textTheme.bodyLarge!,
            onPressed: () async {
              await context.read<LoginCubit>().login();
            },
          );
        } else {
          return const SizedBox(
            width: 50,
            height: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotatePulse,
              colors: [Colors.black],
            ),
          );
        }
      },
    );
  }
}
