import '../core/parser.dart';
import 'package:caldav/src/core/xmlelement.dart' as core;
import 'package:xml/src/xml/utils/node_list.dart';
import 'package:xml/src/xml/nodes/text.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/element.dart';
import '../core/parser_factory.dart';

abstract class WebDavParser<T> extends Parser<T> {
  dynamic parseChildren(XmlNodeList<XmlNode> children) {
    if (children.isEmpty) {
      return null;
    }
    String stringReturnValue;
    List<core.XmlElement> propList = new List<core.XmlElement>();
    for (var child in children) {
      if (child is XmlText) {
        stringReturnValue = child.toString();

        // for some reason during unit test it had 3 items with the first and last ones being line breaks
        // However this did not occur when testing with live data from NextCloud
        // that is why we'll continue with next child if trimmed value is empty.
        // if a non-empty text child occurs, its value will be returned instead.
        // if no child occurs it will return an empty value
        // Note that if a non-XmlText item occurs after an empty text value and no XmlText comes after that, the value will be a List of Non-XmlText items
        if (stringReturnValue.trim().isEmpty) {
          continue;
        }
        return stringReturnValue;
      }

      String name = (child as XmlElement).name.local;
      String namespaceUri = (child as XmlElement).name.namespaceUri;
      try {
        var subparser = ParserFactory().getParser(name, namespaceUri);
        var parsedValue = subparser.parseSingle(child);
        if (parsedValue is String) {
          return parsedValue;
        } else {
          propList.add(parsedValue);
        }
      } on StateError catch (_) {
        throw new UnimplementedError("Missing processor for node " +
            name +
            " in namespace " +
            namespaceUri);
      }
    }
    return propList;
  }
}
