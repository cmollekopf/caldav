import './status.dart';
import './prop.dart';

/// <propstat> element described in RFC 4918
class WebDavPropStat {
  WebDavStatus status;
  List<WebDavProp> props = [];

  /// The propstat XML element MUST contain one prop XML element and one status XML element.
  WebDavPropStat(WebDavProp prop, this.status) {
    this.addProp(prop);
  }

  addProp(WebDavProp prop) {
    this.props.add(prop);
  }
}