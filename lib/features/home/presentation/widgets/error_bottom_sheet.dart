import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_remix/core/utils/gap.dart';
import 'package:photo_remix/features/home/presentation/widgets/primary_button.dart';

class ErrorBottomSheet extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onRetry;

  const ErrorBottomSheet({
    super.key,
    required this.onClose,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(16.px),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
            Center(
              child: Lottie.asset(
                'assets/Warning.json',
                width: 120.px,
                height: 120.px,
                repeat: true,
              ),
            ),
            Gap.h(12),
            Text(
              'Image Generation Failed',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Gap.h(8),
            Text(
              'Something went wrong, try again later!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Gap.h(16),
            PrimaryButton(onPressed: onRetry, label: 'Try Again'),
          ],
        ),
      ),
    );
  }
}
