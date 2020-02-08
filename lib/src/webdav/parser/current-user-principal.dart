import 'package:xml/src/xml/nodes/node.dart';
import '../core/webdav_parser.dart';
import '../property/current-user-principal.dart';

class CurrentUserPrincipalParser extends WebDavParser<WebDavCurrentUserPrincipal> {
  @override
  String getNodeName() {
    return 'current-user-principal';
  }

  @override
  WebDavCurrentUserPrincipal parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }

    var returnValue = new WebDavCurrentUserPrincipal();
    returnValue.setValue(this.parseChildren(node.children));
    return returnValue;
  }
}