import 'package:xml/src/xml/nodes/node.dart';
import '../core/webdav_parser.dart';
import '../property/current-user-principal.dart';

class CurrentUserPrincipalParser extends WebDavParser<WebDavCurrentUserPrincipal> {
  @override
  WebDavCurrentUserPrincipal getGenericInstance() => new WebDavCurrentUserPrincipal();

  @override
  WebDavCurrentUserPrincipal parseSingle(XmlNode node) {
    var returnValue = new WebDavCurrentUserPrincipal();
    returnValue.url = this.parseChildren(node.children);
    return returnValue;
  }
}