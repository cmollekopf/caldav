import 'package:caldav/src/webdav/parser/webdavresponse_parser.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;

import '../../_fixtures/caldav_data.dart' as data;
import 'package:caldav/src/webdav/element/_elements.dart';

bool isHrefProp(o) {
  return o == new WebDavProp('href');
}

void main() {
  test('parse XML into objects', () {
    var xmlDocument = xml.parse(data.nextCloudCurrentUser);

    WebDavResponseParser parser = new WebDavResponseParser();
    var result = parser.parse(xmlDocument);
    expect(result.length, 3);
    expect(result.elementAt(0).href, '/remote.php/caldav/');
    expect(result.elementAt(1).href, '/remote.php/caldav/principals/');
    expect(result.elementAt(2).href, '/remote.php/caldav/calendars/');

    expect(result.elementAt(0).propStats.length, 1);

    var propStat = result.elementAt(0).propStats.elementAt(0);
    expect(propStat.status.status, 'HTTP/1.1 200 OK');
    var currentUserPrincipal = propStat.props.firstWhere((prop) {
      return prop.name == 'current-user-principal' && prop.namespace == 'DAV:';
    });
    var href = currentUserPrincipal.value as List<WebDavProp>;
    var hrefObj = href.firstWhere(isHrefProp);
    expect(hrefObj.value, '/remote.php/caldav/principals/saitho/');
  });

  test('collect namespaces into a Map', () {
    var xmlDocument = xml.parse(data.nextCloudCurrentUser);

    WebDavResponseParser parser = new WebDavResponseParser();
    parser.parse(xmlDocument);

    expect(parser.namespaceMap.length, 4);
    expect(parser.namespaceMap['d'], 'DAV:');
    expect(parser.namespaceMap['s'], 'http://sabredav.org/ns');
    expect(parser.namespaceMap['cal'], 'urn:ietf:params:xml:ns:caldav');
    expect(parser.namespaceMap['cs'], 'http://calendarserver.org/ns/');
  });
}
