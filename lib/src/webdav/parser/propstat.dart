import 'package:caldav/src/webdav/parser/prop.dart';
import 'package:caldav/src/webdav/parser/status.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/element.dart';
import 'package:xml/src/xml/utils/node_list.dart';

import '../core/webdav_parser.dart';
import '../element/_elements.dart';

class PropStatParser extends WebDavParser<WebDavPropStat> {
  PropParser propParser = new PropParser();
  StatusParser statusParser = new StatusParser();

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

    // parse properties and status
    List<WebDavProp> props = propParser.parse(propStat);
    WebDavPropStat propStatObj = new WebDavPropStat(
        props.elementAt(0),
        statusParser.parse(node).first
    );
    propStatObj.props = props;

    return propStatObj;
  }

  @override
  /// No parsing required. Children are processed in [parseSingle]
  dynamic parseChildren(XmlNodeList<XmlNode> children) {
  }
}