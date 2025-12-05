import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_remix/features/home/presentation/widgets/image_picker_bottom_sheet.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_bloc.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_event.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_state.dart';
import 'package:photo_remix/core/theme/app_colors.dart';
import 'package:photo_remix/features/home/presentation/widgets/app_text_button.dart';
import 'package:photo_remix/core/utils/gap.dart';

class ImagePickerCard extends StatelessWidget {
  const ImagePickerCard({super.key});

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => ImagePickerBottomSheet(
            onPickGallery: () {
              Navigator.of(context).pop();
              context.read<ImageGenBloc>().add(const PickFromGallery());
            },
            onPickCamera: () {
              Navigator.of(context).pop();
              context.read<ImageGenBloc>().add(const PickFromCamera());
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final targetHeight = (MediaQuery.of(context).size.height * 0.33);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.px)),
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pick an image',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                BlocBuilder<ImageGenBloc, ImageGenState>(
                  builder: (context, state) {
                    if (state.imagePath == null) {
                      return const SizedBox.shrink();
                    }
                    return AppTextButton(
                      label: 'Clear',
                      onPressed:
                          () => context.read<ImageGenBloc>().add(
                            const ClearImage(),
                          ),
                    );
                  },
                ),
              ],
            ),
            Gap.h(12),
            BlocBuilder<ImageGenBloc, ImageGenState>(
              builder: (context, state) {
                if (state.isLoading && state.imagePath != null) {
                  return SizedBox(
                    height: targetHeight,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.imagePath != null) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(14.px),
                    child: Image.file(
                      File(state.imagePath!),
                      height: targetHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.px),
                    border: Border.all(color: AppColors.border),
                  ),
                  height: targetHeight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.px),
                    onTap: () => _showPicker(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.photo_on_rectangle,
                          size: 36,
                          color: AppColors.primary,
                        ),
                        Gap.h(12),
                        Text(
                          'Tap to choose an image',
                          style: textTheme.bodyMedium,
                        ),
                        Gap.h(12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
