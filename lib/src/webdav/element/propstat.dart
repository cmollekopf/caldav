import './prop.dart';
import './status.dart';
import '../webdav_element.dart';

/// <propstat> element described in RFC 4918
class WebDavPropStat extends WebDavElement {
  WebDavStatus status;

  List<WebDavProp> props = [];

  /// The propstat XML element MUST contain one prop XML element and one status XML element.
  WebDavPropStat(WebDavProp prop, this.status) : super('propstat') {
    this.addProp(prop);
  }

  List<WebDavProp> getProps() {
    return this.props;
  }

  addProp(WebDavProp prop) {
    this.props.add(prop);
  }
}
