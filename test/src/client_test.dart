import 'package:test/test.dart';

import 'package:caldav/src/client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('test regularbase url construction', () async {
    MockClient httpMock = new MockClient((http.Request request) {
      // do stuff
      return Future(() => new http.Response('test', 200));
    });
    CalDavClient client = new CalDavClient(Uri.parse("http://host/path"), 'user', 'password',
        httpClient: httpMock);
    expect(client.baseUrl, 'http://host/path');
  });

  test('test HTTPS base url construction', () async {
    MockClient httpMock = new MockClient((http.Request request) {
      // do stuff
      return Future(() => new http.Response('test', 200));
    });
    CalDavClient client = new CalDavClient(Uri.parse("https://host/path"), 'user', 'password', httpClient: httpMock);
    expect(client.baseUrl, 'https://host/path');
  });

  test('test different port base url construction', () async {
    MockClient httpMock = new MockClient((http.Request request) {
      // do stuff
      return Future(() => new http.Response('test', 200));
    });
    CalDavClient client = new CalDavClient(Uri.parse("http://host:123/path"), 'user', 'password', httpClient: httpMock);
    expect(client.baseUrl, 'http://host:123/path');
  });
}
