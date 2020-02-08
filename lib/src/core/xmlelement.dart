import 'package:xml/src/xml/nodes/element.dart' as xml;
import 'package:xml/src/xml/nodes/node.dart' as xml;

class XmlElement {
  String name;
  String namespace;

  XmlElement({this.name, this.namespace});

  XmlElement.fromXmlNode(xml.XmlNode node) {
    xml.XmlElement element = node as xml.XmlElement;
    this.name = element.name.local;
    this.namespace = element.name.namespaceUri;
  }

  @override
  String toString() {
    return 'XmlElement{name: $name, namespace: $namespace}';
  }

  @override
  bool operator ==(o) {
    return o is XmlElement && name == o.name && namespace == o.namespace;
  }

  String toXmlName() {
    return this.namespace + ':' + this.name;
  }
}