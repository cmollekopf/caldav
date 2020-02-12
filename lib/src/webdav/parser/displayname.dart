import 'package:caldav/src/webdav/property/displayname.dart';
import 'package:xml/src/xml/nodes/node.dart';
import '../webdav_parser.dart';

class DisplayNameParser extends WebDavParser<WebDavDisplayName> {
  @override
  WebDavDisplayName getGenericInstance() => new WebDavDisplayName();

  @override
  WebDavDisplayName parseSingle(XmlNode node) {
    var returnValue = new WebDavDisplayName();
    returnValue.displayName = this.parseChildren(node.children);
    return returnValue;
  }
}
