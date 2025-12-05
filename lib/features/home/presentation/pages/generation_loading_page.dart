import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_remix/core/theme/app_colors.dart';
import 'package:photo_remix/core/utils/gap.dart';

/// Loading view shown while the image is being generated/uploaded.
class GenerationLoadingPage extends StatefulWidget {
  const GenerationLoadingPage({super.key});

  @override
  State<GenerationLoadingPage> createState() => _GenerationLoadingPageState();
}

class _GenerationLoadingPageState extends State<GenerationLoadingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const _text = 'Generating Image....';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.px),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final animProgress = _controller.value;
                final targetLength = (_text.length * animProgress).clamp(
                  0,
                  _text.length,
                );
                final typedText = _text.substring(0, targetLength.toInt());

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/loading.json',
                      width: 180.px,
                      height: 180.px,
                      repeat: true,
                      fit: BoxFit.contain,
                    ),
                    Gap.h(12),
                    Text(
                      typedText,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap.h(16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
