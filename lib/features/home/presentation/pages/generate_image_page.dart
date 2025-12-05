import 'package:flutter/material.dart';
import 'package:photo_remix/core/utils/gap.dart';
import 'package:photo_remix/features/home/presentation/widgets/image_picker_card.dart';
import 'package:photo_remix/features/home/presentation/widgets/select_category_widget.dart';
import 'package:photo_remix/features/home/presentation/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_bloc.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_event.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_state.dart';

/// Section to pick/generate an image.
class GenerateImagePage extends StatelessWidget {
  const GenerateImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ImagePickerCard(),
                Gap.h(16),
                Expanded(
                  child: BlocBuilder<ImageGenBloc, ImageGenState>(
                    builder: (context, state) {
                      return SelectCategoryWidget(
                        initialCategoryId: state.categoryId,
                        onCategorySelected: (category) {
                          context.read<ImageGenBloc>().add(
                            CategorySelected(
                              categoryId: category.id,
                              categoryName: category.name,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Gap.h(16),
              ],
            ),
          ),
          BlocBuilder<ImageGenBloc, ImageGenState>(
            builder: (context, state) {
              final enabled =
                  state.imagePath != null &&
                  state.categoryId != null &&
                  !state.isLoading;
              return PrimaryButton(
                label: 'Generate Image',
                enabled: enabled,
                onPressed:
                    enabled
                        ? () => context.read<ImageGenBloc>().add(
                          const GenerateImageRequested(),
                        )
                        : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
