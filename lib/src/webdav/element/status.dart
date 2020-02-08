import '../core/webdav_element.dart';

/// <status> element described in RFC 4918
class WebDavStatus extends WebDavElement {
  WebDavStatus(this.httpStatus): super('status');

  String httpStatus;

  /// Holds a single HTTP status-line.
  String getStatus() {
    return this.httpStatus;
  }

  @override
  String toString() {
    return this.httpStatus;
  }
}