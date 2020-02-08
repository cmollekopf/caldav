import '../../core/xmlelement.dart';

const webDavNamespace = 'DAV:';

class WebDavElement extends XmlElement {
  WebDavElement(String name) {
    this.name = name;
    this.namespace = webDavNamespace;
  }
}