import 'package:caldav/src/webdav/parser/response.dart';
import 'package:test/test.dart';
import '../../../_fixtures/caldav_data.dart' as data;

import 'package:xml/xml.dart' as xml;

void main() {
  test('parse sample response', () async {
    var processor = new ResponseParser();
    var node = xml.parse(data.nextCloudCurrentUser);
    var result = processor.parse(node);

    // has three results with href
    expect(result.length, 3);
    expect(result.elementAt(0).getHref(), '/remote.php/caldav/');
    expect(result.elementAt(1).getHref(), '/remote.php/caldav/principals/');
    expect(result.elementAt(2).getHref(), '/remote.php/caldav/calendars/');

    // has propstat
    expect(result.elementAt(0).propStats.length, 1);
  });
}
