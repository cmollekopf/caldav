import '../core/xmlelement.dart';

/// Namespace of CalDAV elements
const calDavNamespace = 'urn:ietf:params:xml:ns:caldav';

/// Base class for CalDAV elements
class CalDavElement extends XmlElement {
  /// Constructor for CalDAV elements
  CalDavElement(name) {
    this.name = name;
    namespace = calDavNamespace;
  }
}
