import 'dart:developer' show log;

void logger(String msg, { LogLevel level, Error error, StackTrace stackTrace}) {
  switch (level) {
    case LogLevel.error:
      log(msg, level: 1000, error: error, stackTrace: stackTrace);
      break;
    case LogLevel.warn:
      log(msg, level: 500);
      break;
    case LogLevel.info:
      log(msg);
  }
}

enum LogLevel {
  info,
  warn,
  error
}
