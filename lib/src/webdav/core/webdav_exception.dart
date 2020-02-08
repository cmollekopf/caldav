class WebDavException implements Exception {
  String cause;

  WebDavException(this.cause);
}