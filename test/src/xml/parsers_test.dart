import 'package:caldav/src/caldav/property/calendar-home-set.dart';
import 'package:caldav/src/webdav/parser/response.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;

import '../../_fixtures/caldav_data.dart' as data;
import 'package:caldav/src/core/xmlelement.dart';
import 'package:caldav/src/webdav/property/current-user-principal.dart';

bool isHrefProp(o) {
  return o == new XmlElement(name: 'href');
}

void main() {
  test('parse XML into objects', () {
    var xmlDocument = xml.parse(data.nextCloudCurrentUser);

    ResponseParser parser = new ResponseParser();
    var result = parser.parse(xmlDocument);
    expect(result.length, 3);
    expect(result.elementAt(0).getHref(), '/remote.php/caldav/');
    expect(result.elementAt(1).getHref(), '/remote.php/caldav/principals/');
    expect(result.elementAt(2).getHref(), '/remote.php/caldav/calendars/');

    expect(result.elementAt(0).propStats.length, 1);

    var propStat = result.elementAt(0).propStats.elementAt(0);
    expect(propStat.status.getStatus(), 'HTTP/1.1 200 OK');

    WebDavCurrentUserPrincipal currentUserPrincipal = null;
    for (var prop in propStat.props) {
      currentUserPrincipal = prop.content.firstWhere((val) {
        return val is WebDavCurrentUserPrincipal;
      }, orElse: null);
      if (currentUserPrincipal != null) {
        break;
      }
    }
    expect(currentUserPrincipal.url, '/remote.php/caldav/principals/saitho/');
  });

  test('fetch calendar home', () {
    var xmlDocument = xml.parse(data.nextCloudUserHomeCalendar);

    ResponseParser parser = new ResponseParser();
    var result = parser.parse(xmlDocument);
    expect(result.length, 3);
    expect(result.elementAt(0).href, '/remote.php/caldav/principals/users/saitho/');
    expect(result.elementAt(1).href, '/remote.php/caldav/principals/users/saitho/calendar-proxy-read/');
    expect(result.elementAt(2).href, '/remote.php/caldav/principals/users/saitho/calendar-proxy-write/');

    expect(result.elementAt(0).propStats.length, 1);

    var propStat = result.elementAt(0).propStats.elementAt(0);
    expect(propStat.status.getStatus(), 'HTTP/1.1 200 OK');

    // cal:calendar-home-set
    CalDavCalendarHomeSet home = null;
    for (var prop in propStat.props) {
      home = prop.content.firstWhere((val) {
        return val is CalDavCalendarHomeSet;
      }, orElse: null);
      if (home != null) {
        break;
      }
    }
    expect(home.url, '/remote.php/caldav/calendars/saitho/');
  });

  test('collect namespaces into a Map', () {
    var xmlDocument = xml.parse(data.nextCloudCurrentUser);

    ResponseParser parser = new ResponseParser();
    parser.parse(xmlDocument);

    expect(parser.namespaceMap.length, 4);
    expect(parser.namespaceMap['d'], 'DAV:');
    expect(parser.namespaceMap['s'], 'http://sabredav.org/ns');
    expect(parser.namespaceMap['cal'], 'urn:ietf:params:xml:ns:caldav');
    expect(parser.namespaceMap['cs'], 'http://calendarserver.org/ns/');
  });
}
