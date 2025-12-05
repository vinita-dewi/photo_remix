import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_remix/core/theme/app_text_styles.dart';
import 'package:photo_remix/core/utils/gap.dart';
import 'package:photo_remix/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:photo_remix/features/auth/presentation/bloc/auth_state.dart';
import 'package:photo_remix/features/home/presentation/bloc/home_bloc.dart';
import 'package:photo_remix/features/home/presentation/bloc/home_state.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_bloc.dart';
import 'package:photo_remix/features/image_generation/presentation/bloc/image_gen_state.dart';
import 'generate_image_page.dart';
import 'image_result_page.dart';

/// Root home page that swaps between generator/result views based on state.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photo Remix',
          style: AppTextStyles.textTheme.displayMedium,
          textAlign: TextAlign.left,
        ),
        leading: Image.asset('assets/logo.png', height: 50.px),
        centerTitle: false,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState.status == AuthStatus.unknown) {
            return const Center(child: CircularProgressIndicator());
          }
          if (authState.status == AuthStatus.unauthenticated) {
            return const Center(child: Text('Signing in...'));
          }

          // Authenticated: show home content
          return BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is HomeError) {
                return Center(child: Text('Error: ${state.message}'));
              }

              return BlocBuilder<ImageGenBloc, ImageGenState>(
                builder: (context, imageState) {
                  final showResult =
                      imageState.showResult &&
                      !imageState.isLoading &&
                      imageState.imagePath != null &&
                      imageState.error == null;

                  if (showResult) {
                    return const ImageResultPage();
                  }

                  return const GenerateImagePage();
                },
              );
            },
          );
        },
      ),
    );
  }
}
