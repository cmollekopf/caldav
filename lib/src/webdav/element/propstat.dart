import './prop.dart';
import './status.dart';
import '../core/webdav_element.dart';

/// <propstat> element described in RFC 4918
class WebDavPropStat extends WebDavElement {
  WebDavStatus status;
  dynamic value = [];

  @override
  List<WebDavProp> getValue() {
    return this.value;
  }

  /// The propstat XML element MUST contain one prop XML element and one status XML element.
  WebDavPropStat(WebDavProp prop, this.status): super('propstat') {
    this.addProp(prop);
  }

  addProp(WebDavProp prop) {
    this.value.add(prop);
  }
}