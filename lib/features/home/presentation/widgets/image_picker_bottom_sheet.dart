import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_remix/core/theme/app_colors.dart';
import 'package:photo_remix/features/home/presentation/widgets/app_text_button.dart';
import 'package:photo_remix/core/utils/gap.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;

  const ImagePickerBottomSheet({
    super.key,
    required this.onPickGallery,
    required this.onPickCamera,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.px),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.photo, color: AppColors.primary),
              title: Text('Gallery', style: textTheme.titleMedium),
              onTap: onPickGallery,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.camera, color: AppColors.primary),
              title: Text('Camera', style: textTheme.titleMedium),
              onTap: onPickCamera,
            ),
            Gap.h(12),
            AppTextButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
