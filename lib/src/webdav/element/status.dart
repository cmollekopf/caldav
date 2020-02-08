import '../core/webdav_element.dart';

/// <status> element described in RFC 4918
class WebDavStatus extends WebDavElement<String> {
  String status;

  /// Holds a single HTTP status-line.
  WebDavStatus(this.status): super('status');

  @override
  String toString() {
    return this.status;
  }
}