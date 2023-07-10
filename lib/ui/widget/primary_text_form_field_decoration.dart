import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PrimaryTextFormFieldDecoration extends InputDecoration {
  final BuildContext context;
  final String hint;

  PrimaryTextFormFieldDecoration({required this.context, required this.hint})
      : super(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
          fillColor: AppColors.whiteAlpha18,
          filled: true,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.whiteAlpha18),
          hintText: hint,
        );
}
