import 'package:caldav/src/webdav/webdav_element.dart';
import 'package:caldav/src/webdav/webdav_parser.dart';
import 'package:xml/xml.dart';

class WebDavCurrentUserPrincipal extends WebDavElement {
  WebDavCurrentUserPrincipal() : super('current-user-principal');

  String url;
}

class CurrentUserPrincipalParser
    extends WebDavParser<WebDavCurrentUserPrincipal> {
  @override
  WebDavCurrentUserPrincipal getGenericInstance() =>
      new WebDavCurrentUserPrincipal();

  @override
  WebDavCurrentUserPrincipal parseSingle(XmlNode node) {
    var returnValue = new WebDavCurrentUserPrincipal();
    returnValue.url = this.parseChildren(node.children);
    return returnValue;
  }
}