import 'package:caldav/src/webdav/webdav_element.dart';
import 'package:caldav/src/webdav/webdav_parser.dart';
import 'package:caldav/src/core/xmlelement.dart' as core;
import 'package:xml/xml.dart';

/// <prop> element described in RFC 4918
/// "This element MUST NOT contain text or mixed content."
class WebDavProp extends WebDavElement {
  WebDavProp() : super('prop');

  List<core.XmlElement> content;
}

class PropParser extends WebDavParser<WebDavProp> {
  @override
  WebDavProp getGenericInstance() => new WebDavProp();

  @override
  WebDavProp parseSingle(XmlNode node) {
    XmlElement element = node as XmlElement;
    WebDavProp propObj = new WebDavProp();
    propObj.content = this.parseChildren(element.children);
    return propObj;
  }
}