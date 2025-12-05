import 'package:logger/logger.dart';

/// Centralized logger instance to use across the app.
class AppLogger {
  AppLogger._();
  static final Logger instance = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 90,
      colors: true,
      printEmojis: true,
    ),
  );
}
