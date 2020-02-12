import 'package:caldav/src/webdav/webdav_parser.dart';
import 'package:xml/xml.dart';

import '../webdav_element.dart';

/// <status> element described in RFC 4918
class WebDavStatus extends WebDavElement {
  WebDavStatus(this.httpStatus) : super('status');

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

class StatusParser extends WebDavParser<WebDavStatus> {
  @override
  WebDavStatus getGenericInstance() => WebDavStatus(null);

  @override
  WebDavStatus parseSingle(XmlNode node) {
    return new WebDavStatus(node.text);
  }
}