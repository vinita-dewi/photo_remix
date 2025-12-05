import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_remix/core/theme/app_colors.dart';
import 'package:photo_remix/core/utils/gap.dart';
import 'package:photo_remix/features/home/presentation/widgets/primary_button.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_bloc.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_event.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_state.dart';

/// Shows the generated/selected image. Falls back to the picker if none.
class ImageResultPage extends StatelessWidget {
  const ImageResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetSize = screenWidth * 0.33;
    final borderRadius = BorderRadius.circular(14.px);
    return BlocBuilder<ImageGenBloc, ImageGenState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.imagePath == null || state.error != null) {
          // No result yet; let the HomePage fall back to the generator view.
          return const SizedBox.shrink();
        }

        final image = File(state.imagePath!);
        final generatedUrls = state.generatedImageUrls;

        return Container(
          color: AppColors.onPrimary,
          child: Padding(
            padding: EdgeInsets.all(16.px),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Original Image',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Gap.h(16),
                Center(
                  child: SizedBox(
                    width: targetSize,
                    height: targetSize,
                    child: ClipRRect(
                      borderRadius: borderRadius,
                      child: Image.file(image, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Gap.h(20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Generated Image',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Gap.h(20),
                Expanded(
                  child: GridView.builder(
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final hasGenerated =
                          generatedUrls.isNotEmpty &&
                          index < generatedUrls.length;
                      final widget = hasGenerated
                          ? Image.network(
                              generatedUrls[index],
                              fit: BoxFit.cover,
                            )
                          : Image.file(image, fit: BoxFit.cover);
                      return ClipRRect(
                        borderRadius: borderRadius,
                        child: Container(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          child: widget,
                        ),
                      );
                    },
                  ),
                ),
                Gap.h(8),
                SafeArea(
                  top: false,
                  child: PrimaryButton(
                    onPressed: () {
                      context.read<ImageGenBloc>().add(const ClearImage());
                      Navigator.of(context).maybePop();
                    },
                    label: 'Generate New Image!',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
