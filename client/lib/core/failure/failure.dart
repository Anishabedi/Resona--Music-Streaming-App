class AppFailure {
  final String message;
  // final int statusCode;
  AppFailure([this.message = 'Sorry, an unexpected error occurred!']);

  @override
  String toString() => 'AppFailure(message: $message)';
}