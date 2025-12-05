import 'package:flutter/widgets.dart';

/// Handy spacing helper that scales raw pixel values against the current
/// device's pixel ratio so gaps remain visually consistent across screens.
class Gap {
  const Gap._();

  /// Converts a Figma px value to a responsive logical pixel value.
  static double _toLogicalPixels(double px) {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final view = dispatcher.views.isNotEmpty ? dispatcher.views.first : null;

    // Fall back to window if views list is empty (older API compatibility).
    final logicalWidth =
        view?.physicalSize.width != null && view?.devicePixelRatio != null
            ? view!.physicalSize.width / view.devicePixelRatio
            : WidgetsBinding.instance.window.physicalSize.width /
                WidgetsBinding.instance.window.devicePixelRatio;

    // Scale relative to a 390px wide design (common Figma iPhone reference),
    // clamped to avoid extreme values on very small/large screens.
    const baseWidth = 390.0;
    final scale = (logicalWidth / baseWidth).clamp(0.75, 1.25);
    return px * scale;
  }

  /// Horizontal gap: `Gap.w(20)`.
  static SizedBox w(double px) => SizedBox(width: _toLogicalPixels(px));

  /// Vertical gap: `Gap.h(12)`.
  static SizedBox h(double px) => SizedBox(height: _toLogicalPixels(px));
}

/// Extension to convert physical pixels to logical pixels responsively: `20.px`.
extension ResponsivePixels on num {
  double get px => Gap._toLogicalPixels(toDouble());
}
