import 'package:caldav/src/webdav/element/prop.dart';
import 'package:caldav/src/webdav/element/status.dart';
import 'package:caldav/src/webdav/webdav_element.dart';
import 'package:caldav/src/webdav/webdav_parser.dart';
import 'package:xml/xml.dart';
import 'package:xml/src/xml/utils/node_list.dart';


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

class PropStatParser extends WebDavParser<WebDavPropStat> {
  PropParser propParser = new PropParser();
  StatusParser statusParser = new StatusParser();

  @override
  WebDavPropStat getGenericInstance() => new WebDavPropStat(null, null);

  @override
  WebDavPropStat parseSingle(XmlNode node) {
    XmlElement propStat = node as XmlElement;

    // parse properties and status
    List<WebDavProp> props = propParser.parse(propStat);
    WebDavPropStat propStatObj =
    new WebDavPropStat(props.elementAt(0), statusParser.parse(node).first);
    propStatObj.props = props;

    return propStatObj;
  }

  @override

  /// No parsing required. Children are processed in [parseSingle]
  dynamic parseChildren(XmlNodeList<XmlNode> children) {}
}
