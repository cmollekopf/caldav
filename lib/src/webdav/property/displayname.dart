import 'package:caldav/src/webdav/webdav_parser.dart';
import 'package:xml/xml.dart';

import '../webdav_element.dart';

class WebDavDisplayName extends WebDavElement {
  WebDavDisplayName() : super('displayname');

  String displayName;
}

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