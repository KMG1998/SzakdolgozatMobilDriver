import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szakdolgozat_mobil_driver_side/models/review.dart';
import 'package:szakdolgozat_mobil_driver_side/qubit/order/order_cubit.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/app_decoration.dart';
import 'package:szakdolgozat_mobil_driver_side/theme/theme_helper.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_text_form_field.dart';

class OrderReviewDialog extends StatefulWidget {
  const OrderReviewDialog({super.key});

  @override
  State<OrderReviewDialog> createState() => _OrderReviewDialogState();
}

class _OrderReviewDialogState extends State<OrderReviewDialog> {
  double reviewScore = 3;
  final TextEditingController reviewTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return Container(
            width: 550.w,
            height: 400.h,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.circleBorder15,
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Utas értékelés',
                  style: theme.textTheme.headlineLarge,
                ),
                SizedBox(height: 20),
                Text(
                  'Kérjük, értékelje az utast!',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  reviewScore.toString(),
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 500.w,
                  child: Slider(
                      value: reviewScore,
                      activeColor: ThemeHelper().themeColor().blue10001,
                      divisions: 8,
                      label: reviewScore.toString(),
                      min: 1,
                      max: 5,
                      onChanged: (val) {
                        setState(() {
                          reviewScore = val;
                        });
                      }),
                ),
                SizedBox(
                  height: 80,
                  width: 500.w,
                  child: CustomTextFormField(
                    controller: reviewTextController,
                    hintText: 'Szöveges értékelés',
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomOutlinedButton(
                      text: 'Most nem',
                      width: 200.w,
                      onPressed: () => {Navigator.pop(context)},
                    ),
                    Expanded(child: SizedBox()),
                    CustomOutlinedButton(
                      text: 'Értékelés',
                      width: 200.w,
                      onPressed: () => {
                        Navigator.pop(
                            context,
                            Review(
                              score: reviewScore,
                              reviewText: reviewTextController.text,
                            ))
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
