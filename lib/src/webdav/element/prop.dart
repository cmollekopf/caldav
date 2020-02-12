import '../core/webdav_element.dart';
import '../../core/xmlelement.dart';

/// <prop> element described in RFC 4918
/// "This element MUST NOT contain text or mixed content."
class WebDavProp extends WebDavElement {
  WebDavProp() : super('prop');

  List<XmlElement> content;
}
