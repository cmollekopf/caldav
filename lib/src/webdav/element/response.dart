import './propstat.dart';
import '../core/webdav_element.dart';

/// <response> element described in RFC 4918
class WebDavResponse extends WebDavElement<String> {
  WebDavResponse(): super('response');

  /// "value" attribute is used for href element
  /// The 'href' element contains an HTTP URL pointing to a WebDAV resource when used in the 'response' container.
  String getHref() {
    return this.getValue();
  }

  List<WebDavPropStat> propStats;
}