import 'package:xml/src/xml/nodes/node.dart';
import '../element/status.dart';
import '../core/webdav_parser.dart';

class StatusParser extends WebDavParser<WebDavStatus> {
  @override
  WebDavStatus getGenericInstance() => WebDavStatus(null);

  @override
  WebDavStatus parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }
    return new WebDavStatus(node.text);
  }
}