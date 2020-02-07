import 'package:xml/src/xml/nodes/node.dart';
import '../element/status.dart';
import '../core/webdav_parser.dart';

class WebDavStatusParser extends WebDavParser<WebDavStatus> {
  @override
  String getNodeName() {
    return 'status';
  }

  @override
  WebDavStatus parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }
    return new WebDavStatus(node.text);
  }
}