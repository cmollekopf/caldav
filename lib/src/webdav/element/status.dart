/// <status> element described in RFC 4918
class WebDavStatus {
  String status;

  /// Holds a single HTTP status-line.
  WebDavStatus(this.status);

  @override
  String toString() {
    return this.status;
  }
}