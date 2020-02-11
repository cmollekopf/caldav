import 'package:caldav/src/core/parser.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;

import '../../_fixtures/caldav_data.dart' as data;
import 'package:caldav/src/core/xmlelement.dart';

bool isHrefProp(o) {
  return o == new XmlElement(name: 'href');
}

class TestParser extends Parser<String> {
  @override
  String getGenericInstance() => '';

  @override
  String getNodeName() => 'multistatus';

  @override
  String getNodeNamespace() => 'DAV:';

  @override
  String parseSingle(xml.XmlNode node) => '';

}

void main() {
  test('collect namespaces into a Map', () {
    var xmlDocument = xml.parse(data.nextCloudCurrentUser);

    TestParser parser = new TestParser();
    parser.parse(xmlDocument.rootElement);

    expect(parser.namespaceMap.length, 4);
    expect(parser.namespaceMap['d'], 'DAV:');
    expect(parser.namespaceMap['s'], 'http://sabredav.org/ns');
    expect(parser.namespaceMap['cal'], 'urn:ietf:params:xml:ns:caldav');
    expect(parser.namespaceMap['cs'], 'http://calendarserver.org/ns/');
  });
}
