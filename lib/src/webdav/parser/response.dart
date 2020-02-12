import 'package:caldav/src/webdav/webdav_element.dart';
import 'package:caldav/src/core/parser_factory.dart';
import 'package:caldav/src/webdav/parser/propstat.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/document.dart';
import 'package:xml/src/xml/nodes/element.dart';
import '../element/_elements.dart';
import '../webdav_parser.dart';

class ResponseParser extends WebDavParser<WebDavResponse> {
  @override
  WebDavResponse getGenericInstance() => new WebDavResponse();

  List<WebDavResponse> parse(XmlNode node) {
    return super.parse((node as XmlDocument).rootElement);
  }

  @override
  WebDavResponse parseSingle(XmlNode node) {
    XmlElement response = node as XmlElement;
    WebDavResponse responseObj = new WebDavResponse();

    responseObj.href = ParserFactory()
        .getParser('href', webDavNamespace)
        .parse(response)
        .first;
    responseObj.propStats = new PropStatParser().parse(response);
    return responseObj;
  }
}
