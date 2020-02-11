import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/element.dart';

import '../core/webdav_parser.dart';
import '../element/_elements.dart';

class PropParser extends WebDavParser<WebDavProp> {
  @override
  WebDavProp getGenericInstance() => new WebDavProp();

  @override
  WebDavProp parseSingle(XmlNode node) {
    XmlElement element = node as XmlElement;
    WebDavProp propObj = new WebDavProp();
    propObj.content = this.parseChildren(element.children);
    return propObj;
  }
}