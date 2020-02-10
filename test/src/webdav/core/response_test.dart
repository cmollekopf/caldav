import 'package:caldav/src/webdav/core/response.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import '../../../_fixtures/caldav_data.dart' as data;

import 'package:caldav/src/core/xmlelement.dart';

bool isHrefProp(o) {
  return o == new XmlElement(name: 'href');
}

void main() {
  test('sanitize path', () {
    var httpResponse = new http.Response(data.nextCloudUserHomeCalendar, 200);
    var requestPath = 'abc';
    var response = new Response(httpResponse, requestPath);

    expect(response.sanitizePath('/test/'), 'test'); // remove first and last slash
    expect(response.sanitizePath('/test'), 'test'); // remove first slash
    expect(response.sanitizePath('test/'), 'test'); // remove last slash
    expect(response.sanitizePath('/abc/test/'), 'test'); // remove requestPath
    expect(response.sanitizePath('/abc/test'), 'test'); // remove requestPath
  });

  test('get full path', () {
    var httpResponse = new http.Response(data.nextCloudUserHomeCalendar, 200);
    var requestPath = 'abc';
    var response = new Response(httpResponse, requestPath);

    expect(response.getFullPath('my-path'), '/abc/my-path/');
    expect(response.getFullPath('/my-path2/'), '/abc/my-path2/');
    expect(response.getFullPath(''), '/abc/');
  });
}
