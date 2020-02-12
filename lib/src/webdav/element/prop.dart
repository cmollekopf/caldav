import 'package:xml/xml.dart';
import '../../core/xmlelement.dart' as core;
import '../webdav_element.dart';
import '../webdav_parser.dart';

/// <prop> element described in RFC 4918
/// "This element MUST NOT contain text or mixed content."
class WebDavProp extends WebDavElement {
  WebDavProp() : super('prop');

  List<core.XmlElement> content;
}

class PropParser extends WebDavParser<WebDavProp> {
  @override
  WebDavProp getGenericInstance() => WebDavProp();

  @override
  WebDavProp parseSingle(XmlNode node) {
    var element = node as XmlElement;
    var propObj = WebDavProp();
    propObj.content = parseChildren(element.children);
    return propObj;
  }
}
