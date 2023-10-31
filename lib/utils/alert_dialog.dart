import 'package:flutter/material.dart';
import 'package:flutter_survey/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

void showAppDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String positiveButtonText,
  required String negativeButtonText,
  required VoidCallback onPositiveButtonClick,
  required VoidCallback onNegativeButtonClick,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: AppColors.nero90,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w800),
        ),
        content: Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w400),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: <Widget>[
          const Divider(color: AppColors.gunPowder, height: 0.5),
          IntrinsicHeight(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              buttonPadding: EdgeInsets.zero,
              buttonHeight: 43.5,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    context.pop();
                    onPositiveButtonClick();
                  },
                  child: Text(positiveButtonText),
                ),
                const VerticalDivider(color: AppColors.gunPowder, width: 0.5),
                TextButton(
                  onPressed: () {
                    context.pop();
                    onNegativeButtonClick();
                  },
                  child: Text(negativeButtonText),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
