import './propstat.dart';

/// <response> element described in RFC 4918
class WebDavResponse {
  /// The 'href' element contains an HTTP URL pointing to a WebDAV resource when used in the 'response' container.
  String href;
  List<WebDavPropStat> propStats;
}