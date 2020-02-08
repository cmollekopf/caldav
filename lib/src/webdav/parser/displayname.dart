import 'package:caldav/src/webdav/property/displayname.dart';
import 'package:xml/src/xml/nodes/node.dart';
import '../core/webdav_parser.dart';

class DisplayNameParser extends WebDavParser<WebDavDisplayName> {
  @override
  String getNodeName() {
    return 'displayname';
  }

  @override
  WebDavDisplayName parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }

    var returnValue = new WebDavDisplayName();
    returnValue.displayName = this.parseChildren(node.children);
    return returnValue;
  }
}