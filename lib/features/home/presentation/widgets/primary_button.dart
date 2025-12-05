import 'package:flutter/material.dart';
import 'package:photo_remix/core/theme/app_colors.dart';
import 'package:photo_remix/core/theme/app_text_styles.dart';
import 'package:photo_remix/core/utils/gap.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = enabled && !isLoading ? onPressed : null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 14.px),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.px),
          ),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 20.px,
                  width: 20.px,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
                : Text(
                  label,
                  style: AppTextStyles.textTheme.labelLarge?.copyWith(
                    color: AppColors.white,
                  ),
                ),
      ),
    );
  }
}
