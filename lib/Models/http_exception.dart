class HTTPExtension implements Exception {
  final String message;
  HTTPExtension(this.message);
  @override
  String toString() {
    return message;
  }
}
