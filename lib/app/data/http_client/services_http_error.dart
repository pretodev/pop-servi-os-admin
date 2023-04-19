class ServicesHttpError implements Exception {
  final String message;
  final int statusCode;

  ServicesHttpError({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() =>
      'ServicesHttpError(message: $message, statusCode: $statusCode)';
}
