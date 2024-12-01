class CalendarException implements Exception {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  CalendarException(
    this.message, {
    this.error,
    this.stackTrace,
  });

  @override
  String toString() {
    if (error != null) {
      return 'CalendarException: $message (Error: $error)';
    }
    return 'CalendarException: $message';
  }
}

// 더 구체적인 예외들도 정의할 수 있습니다
class CalendarNetworkException extends CalendarException {
  CalendarNetworkException(super.message, {super.error, super.stackTrace});
}

class CalendarNotFoundException extends CalendarException {
  CalendarNotFoundException(super.message, {super.error, super.stackTrace});
}

class CalendarAuthException extends CalendarException {
  CalendarAuthException(super.message, {super.error, super.stackTrace});
}
