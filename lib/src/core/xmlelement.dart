import 'package:xml/src/xml/nodes/element.dart' as xml;
import 'package:xml/src/xml/nodes/node.dart' as xml;
import '../core/generics-initializer.dart';

class XmlElement<T> {
  String name;
  String namespace;
  T _value;

  XmlElement({this.name, this.namespace});

  XmlElement.fromXmlNode(xml.XmlNode node) {
    xml.XmlElement element = node as xml.XmlElement;
    this.name = element.name.local;
    this.namespace = element.name.namespaceUri;
  }

  void setValue(T value) {
    this._value = value;
  }

  T getValue() {
    if (this._value == null) {
      this._value = GenericsInitializer.create<T>();
    }
    return this._value;
  }

  @override
  String toString() {
    return 'XmlElement{name: $name, namespace: $namespace, value: ${getValue()}}';
  }

  @override
  bool operator ==(o) {
    return o is XmlElement && name == o.name && namespace == o.namespace;
  }

  String toXmlName() {
    return this.namespace + ':' + this.name;
  }
}