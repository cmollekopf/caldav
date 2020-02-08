import '../../core/xmlelement.dart';

const webDavNamespace = 'DAV:';

class WebDavElement<T> extends XmlElement<T> {
  WebDavElement(String name) {
    this.name = name;
    this.namespace = webDavNamespace;
  }
}