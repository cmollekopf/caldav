import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/element.dart';

import '../core/webdav_parser.dart';
import '../element/_elements.dart';

class PropParser extends WebDavParser<WebDavProp> {
  @override
  String getNodeName() {
    return 'prop';
  }

  @override
  WebDavProp parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }

    XmlElement element = node as XmlElement;
    WebDavProp propObj = new WebDavProp();
    propObj.setValue(this.parseChildren(element.children));
    return propObj;
  }
}