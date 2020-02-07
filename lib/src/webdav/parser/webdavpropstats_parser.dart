import 'package:caldav/src/webdav/parser/webdavprop_parser.dart';
import 'package:caldav/src/webdav/parser/status_parser.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/element.dart';
import 'package:xml/src/xml/nodes/text.dart';

import '../core/webdav_parser.dart';
import '../element/_elements.dart';

class WebDavPropStatsParser extends WebDavParser<WebDavPropStat> {
  WebDavPropParser propParser = new WebDavPropParser();
  WebDavStatusParser statusParser = new WebDavStatusParser();

  @override
  String getNodeName() {
    return 'propstat';
  }

  @override
  WebDavPropStat parseSingle(XmlNode node, {bool rescanNs = false}) {
    XmlElement propStat = node as XmlElement;
    if (rescanNs) {
      this.updateNamespaces(node);
    }

    // todo: think about skipping if HTTP status for propStat is not 200
    List<WebDavProp> props = [];
    // prop is DAV:prop
    String davNamespace = this.pathToNamespaceMap['DAV:'];
    propStat.findElements(davNamespace + ':prop').forEach((prop) {
      prop.children.forEach((child) {
        if (child is XmlText) {
          return;
        }
        // todo: use parse() instead
        props.add(propParser.parseSingle(child, rescanNs: true));
      });
    });

    WebDavPropStat propStatObj = new WebDavPropStat(
        props.elementAt(0),
        statusParser.parse(node).first
    );
    return propStatObj;
  }
}