import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/toast_wrapper.dart';
import 'package:szakdolgozat_mobil_driver_side/core/utils/validators.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/auth/auth_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/app_decoration.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_text_form_field.dart';

class ForgotPasswordDialog extends StatefulWidget {
  ForgotPasswordDialog({super.key});

  final _emailFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 550.w,
        height: 450.h,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusStyle.circleBorder15,
          color: Colors.white,
        ),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is PasswordResetInProgress) {
              return LoadingIndicator(
                indicatorType: Indicator.ballClipRotatePulse,
                colors: [Colors.black],
              );
            }
            if (state is PasswordResetFail) {
              ToastWrapper.showErrorToast(message: "Sikertelen művelet!");
            }
            return state is PasswordResetSuccess ? _successContent() : _resetForm();
          },
        ),
      ),
    );
  }

  _resetForm() {
    return Form(
      key: widget._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Elfelejtett jelszó',
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 20),
          Text(
            'Kérjük, adja meg a belépéshez használt e-mail címét. '
            'Amennyiben van regisztrált felhasználó a megadott e-mail címmel, küldeni fogunk egy e-mailt egy átmeneti jelszóval a megadott címre.',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'E-mail',
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 10),
          CustomTextFormField(
            autofocus: false,
            controller: widget._emailFieldController,
            validator: (email) => Validators.emailValidator(email),
          ),
          Expanded(child: SizedBox()),
          CustomOutlinedButton(
              text: 'Jelszó visszaállítása',
              buttonTextStyle: theme.textTheme.titleLarge,
              onPressed: () {
                if (widget._formKey.currentState!.validate()) {
                  context.read<AuthCubit>().resetPassword(email: widget._emailFieldController.text);
                }
              }),
        ],
      ),
    );
  }

  _successContent() {
    return Center(
      child: Text(
          'Sikeres művelet! Amennyiben létezik a megadott e-mail címmel használó a rendszerünkben, kiküldtünk egy átmenetei jelszót tartalmazó emailt.'),
    );
  }
}
