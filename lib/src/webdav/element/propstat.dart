import './prop.dart';
import './status.dart';
import '../core/webdav_element.dart';

/// <propstat> element described in RFC 4918
class WebDavPropStat extends WebDavElement<List<WebDavProp>> {
  WebDavStatus status;

  /// The propstat XML element MUST contain one prop XML element and one status XML element.
  WebDavPropStat(WebDavProp prop, this.status): super('propstat') {
    this.addProp(prop);
  }

  addProp(WebDavProp prop) {
    this.getValue().add(prop);
  }
}