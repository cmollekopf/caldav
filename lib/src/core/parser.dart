import 'package:caldav/src/core/xmlelement.dart' as core;
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/element.dart';
import 'package:xml/src/xml/nodes/attribute.dart';
import 'package:xml/src/xml/nodes/document.dart';

abstract class Parser<T> {
  /// provides an instance of the object that is created.
  /// If it is a [package:caldav/src/core/xmlelement.dart], name and namespace will be fetched from there.
  /// If it is not, please also override [getNodeNamespace] and [getNodeName].
  T getGenericInstance();

  String getNodeName() {
    T instance = this.getGenericInstance();
    if (instance is core.XmlElement) {
      return instance.name;
    }
    return null;
  }

  String getNodeNamespace() {
    T instance = this.getGenericInstance();
    if (instance is core.XmlElement) {
      return instance.namespace;
    }
    return null;
  }

  String getFullName() {
    String namespaceUrn = this.getNodeNamespace();
    if (!this.pathToNamespaceMap.containsKey(namespaceUrn)) {
      throw new ArgumentError('Unknown namespace path ' + namespaceUrn);
    }
    return this.pathToNamespaceMap[namespaceUrn] + ':' + this.getNodeName();
  }

  /// maps ns => full/namespace/urn
  Map<String, String> namespaceMap = {};

  /// maps full/namespace/urn => ns
  Map<String, String> pathToNamespaceMap = {};

  updateNamespaces(XmlNode node) {
    List<XmlAttribute> xmlAttributes = collectParentAttributes(node);
    // todo: consider global xmlns as well
    RegExp re = new RegExp(r'xmlns:(\w+)="([\w\W]+)"');
    xmlAttributes
        .removeWhere((attribute) => !re.hasMatch(attribute.toString()));

    this.namespaceMap = {};
    xmlAttributes.forEach((attribute) {
      re.allMatches(attribute.toString()).forEach((match) {
        String name = match.group(1);
        String path = match.group(2);
        namespaceMap[name] = path;
        pathToNamespaceMap[path] = name;
      });
    });
  }

  List<XmlAttribute> collectParentAttributes(XmlNode node) {
    List<XmlAttribute> attributes = [];

    // If node is XMlDocument take attributes from rootElement
    if (node is XmlDocument) {
      node = (node as XmlDocument).rootElement;
    }

    attributes.addAll(node.attributes);

    if (node.hasParent && !(node.parent is XmlDocument)) {
      var parentAttributes = collectParentAttributes(node.parent);
      parentAttributes
          .removeWhere((attribute) => attributes.indexOf(attribute) != -1);
      attributes.addAll(parentAttributes);
    }
    return attributes;
  }

  List<T> parse(XmlNode node) {
    this.updateNamespaces(node);
    List<T> list = [];

    (node as XmlElement).findAllElements(this.getFullName()).forEach((element) {
      list.add(parseSingle(element));
    });

    return list;
  }

  T parseSingle(XmlNode node);
}
