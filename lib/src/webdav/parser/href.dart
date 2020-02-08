import 'package:xml/src/xml/nodes/node.dart';
import '../core/webdav_parser.dart';

class HrefParser extends WebDavParser<String> {
  @override
  String getNodeName() {
    return 'href';
  }

  @override
  String parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }
    return node.text;
  }
}