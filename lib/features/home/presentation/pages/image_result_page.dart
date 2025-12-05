import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final targetHeight = MediaQuery.of(context).size.height * 0.33;
    return BlocBuilder<ImageGenBloc, ImageGenState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.imagePath == null || state.error != null) {
          // No result yet; let the HomePage fall back to the generator view.
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.all(16.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Image Result',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Gap.h(12),
              ClipRRect(
                borderRadius: BorderRadius.circular(14.px),
                child: Image.file(
                  File(state.imagePath!),
                  fit: BoxFit.cover,
                  height: targetHeight,
                ),
              ),
              Gap.h(12),
              PrimaryButton(
                onPressed:
                    () => context.read<ImageGenBloc>().add(const ClearImage()),
                label: 'Generate Another',
              ),
            ],
          ),
        );
      },
    );
  }
}
