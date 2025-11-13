import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to show
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 100, // width of the output
      colors: true,
      printEmojis: true,
    ),
  );

  static void d(String message, [dynamic data]) =>
      _logger.d('$message ${data ?? ''}');

  static void i(String message, [dynamic data]) =>
      _logger.i('$message ${data ?? ''}');

  static void w(String message, [dynamic data]) =>
      _logger.w('$message ${data ?? ''}');

  static void e(String message, [dynamic data]) =>
      _logger.e('$message ${data ?? ''}');
}
