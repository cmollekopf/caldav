import 'package:caldav/src/webdav/core/webdav_element.dart';
import 'package:caldav/src/core/parser_factory.dart';
import 'package:caldav/src/webdav/parser/propstat.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/src/xml/nodes/document.dart';
import 'package:xml/src/xml/nodes/element.dart';
import '../element/_elements.dart';
import '../core/webdav_parser.dart';

class ResponseParser extends WebDavParser<WebDavResponse> {

  @override
  WebDavResponse getGenericInstance() => new WebDavResponse();

  List<WebDavResponse> parse(XmlNode node) {
    this.updateNamespaces(node);
    List<WebDavResponse> list = [];

    XmlDocument document = node as XmlDocument;

    document.findAllElements(this.getFullName()).forEach((element) {
      list.add(parseSingle(element));
    });

    return list;
  }

  @override
  WebDavResponse parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }
    XmlElement response = node as XmlElement;
    WebDavResponse responseObj = new WebDavResponse();

    responseObj.href = ParserFactory().getParser('href', webDavNamespace).parse(response).first;
    responseObj.propStats = new PropStatParser().parse(response);
    return responseObj;
  }
}