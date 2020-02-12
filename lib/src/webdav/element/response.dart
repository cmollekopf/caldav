import 'package:caldav/src/core/parser_factory.dart';
import 'package:caldav/src/webdav/element/propstat.dart';
import 'package:caldav/src/webdav/webdav_element.dart';
import 'package:caldav/src/webdav/webdav_parser.dart';
import 'package:xml/xml.dart';

/// <response> element described in RFC 4918
class WebDavResponse extends WebDavElement {
  WebDavResponse() : super('response');

  /// The 'href' element contains an HTTP URL pointing to a WebDAV resource when used in the 'response' container.
  String href;

  String getHref() {
    return this.href;
  }

  List<WebDavPropStat> propStats;
}

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
