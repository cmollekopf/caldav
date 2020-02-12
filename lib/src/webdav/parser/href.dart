import 'package:caldav/src/webdav/webdav_element.dart';
import 'package:xml/src/xml/nodes/node.dart';
import '../webdav_parser.dart';

class HrefParser extends WebDavParser<String> {
  @override
  String getGenericInstance() => '';

  @override
  String getNodeName() => 'href';

  @override
  String getNodeNamespace() => webDavNamespace;

  @override
  String parseSingle(XmlNode node) {
    return node.text;
  }
}
