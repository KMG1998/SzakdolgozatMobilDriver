import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szakdolgozat_mobil_driver_side/core/app_export.dart';
import 'package:szakdolgozat_mobil_driver_side/widgets/custom_outlined_button.dart';


class ReserveAcceptedPopupDialog extends StatelessWidget {
  const ReserveAcceptedPopupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _buildNewReserveBody(context),
    );
  }

  /// Section Widget
  Widget _buildNewReserveBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 53.h,
        right: 53.h,
        bottom: 354.w,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 30.w,
      ),
      decoration: AppDecoration.fillOnSecondaryContainer.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "foglalás jóváhagyva",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 43.w),
          Container(
            width: 442.h,
            margin: EdgeInsets.only(
              left: 38.h,
              right: 39.h,
            ),
            child: Text(
              "Foglalását elogadták, a jármű várható érkezési ideje: 15:30",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 85.w),
          CustomOutlinedButton(
            text: "tovább",
          ),
          SizedBox(height: 9.w),
        ],
      ),
    );
  }
}
