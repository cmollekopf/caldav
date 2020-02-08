import '../core/xmlelement.dart';

const calDavNamespace = 'urn:ietf:params:xml:ns:caldav';

class CalDavElement<T> extends XmlElement<T> {
  CalDavElement(String name) {
    this.name = name;
    this.namespace = calDavNamespace;
  }
}