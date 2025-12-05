import 'package:flutter/material.dart';
import 'package:photo_remix/core/theme/app_colors.dart';

class CategoryTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryTag({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.primary
        : AppColors.primary.withOpacity(0.12);
    final textColor = selected ? AppColors.white : AppColors.textPrimary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
