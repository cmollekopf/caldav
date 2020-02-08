import '../core/webdav_element.dart';
import '../../core/xmlelement.dart';

/// <prop> element described in RFC 4918
class WebDavProp extends WebDavElement {
  WebDavProp(): super('prop');

  @override
  String toString() {
    return 'WebDavProp{value: ${value.toString()}';
  }

  @override
  /// value is of type List<core.XmlElement>
  /// RFC: "This element MUST NOT contain text or mixed content."
  List<XmlElement> getValue() {
    return this.value;
  }
}