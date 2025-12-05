import 'package:flutter/material.dart';
import 'package:photo_remix/core/theme/app_colors.dart';
import 'package:photo_remix/core/theme/app_text_styles.dart';

class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.textTheme.titleSmall?.copyWith(
          color: color ?? AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
