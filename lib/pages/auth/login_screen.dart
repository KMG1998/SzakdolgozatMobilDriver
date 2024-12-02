import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:szakdolgozat_mobil_driver_side/core/popups/forgot_password_dialog.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/toast_wrapper.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/validators.dart';
import 'package:szakdolgozat_mobil_driver_side/generated/assets.gen.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/auth/auth_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/routes/app_routes.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/custom_button_style.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_image_view.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
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
                          key: context.read<AuthCubit>().formKey,
                          child: Column(
                            children: [
                              CustomImageView(
                                imagePath: Assets.lib.assets.images.magantaxiLogo.path,
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
                                controller: context.read<AuthCubit>().emailInputController,
                                validator: (email) => Validators.emailValidator(email),
                                focusNode: context.read<AuthCubit>().emailFocus,
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
                                controller: context.read<AuthCubit>().passwordInputController,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                autoCorrect: false,
                                enableSuggestions: false,
                                focusNode: context.read<AuthCubit>().passwordFocus,
                                validator: (password) => Validators.passwordValidator(password),
                                autofocus: false,
                              ),
                              SizedBox(height: 32.h),
                              _loginButton(),
                              SizedBox(height: 52.h),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ForgotPasswordDialog();
                                      }).then((value) {
                                    context.read<AuthCubit>().reset();
                                  });
                                },
                                child: Text(
                                  "Elfelejtett jelszó",
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
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
        style: theme.textTheme.titleLarge,
      ),
    );
  }

  _loginButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.driverDashboardScreen);
        }
        if (state is AuthFail) {
          ToastWrapper.showErrorToast(message: "Érvénytelen e-mail vagy jelszó");
        }
      },
      builder: (context, state) {
        if (state is AuthInProgress == false) {
          return CustomOutlinedButton(
            height: 28,
            width: 269,
            text: "Belépés",
            buttonStyle: CustomButtonStyles.outlineBlack,
            buttonTextStyle: theme.textTheme.bodyLarge!,
            onPressed: () {
              context.read<AuthCubit>().login();
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
