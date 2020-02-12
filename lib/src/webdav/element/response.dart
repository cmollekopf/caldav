import './propstat.dart';
import '../webdav_element.dart';

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
