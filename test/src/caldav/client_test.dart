import 'package:test/test.dart';
import 'dart:convert';

import 'package:caldav/src/caldav/client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../_fixtures/caldav_data.dart' as data;

class MockClient extends Mock implements http.BaseClient {}

void main() {
  test('test regularbase url construction', () async {
    MockClient httpMock = new MockClient();
    when(httpMock.send(any)).thenAnswer(
            (_) async => new http.StreamedResponse(
                new http.ByteStream.fromBytes(List<int>()),
                200
            )
    );
    CalDavClient client = new CalDavClient('host', 'user', 'password', 'path', httpClient: httpMock);
    expect(client.baseUrl, 'http://host/path');
  });

  test('test HTTPS base url construction', () async {
    MockClient httpMock = new MockClient();
    when(httpMock.send(any)).thenAnswer(
            (_) async => new http.StreamedResponse(
            new http.ByteStream.fromBytes(List<int>()),
            200
        )
    );
    CalDavClient client = new CalDavClient('host', 'user', 'password', 'path', protocol: 'https', httpClient: httpMock);
    expect(client.baseUrl, 'https://host/path');
  });

  test('test different port base url construction', () async {
    MockClient httpMock = new MockClient();
    when(httpMock.send(any)).thenAnswer(
            (_) async => new http.StreamedResponse(
            new http.ByteStream.fromBytes(List<int>()),
            200
        )
    );
    CalDavClient client = new CalDavClient('host', 'user', 'password', 'path', port: 123, httpClient: httpMock);
    expect(client.baseUrl, 'http://host:123/path');
  });

  test('test getting current user principal', () async {
    MockClient httpMock = new MockClient();

    List<String> responses = [data.nextCloudCurrentUser];
    when(httpMock.send(any)).thenAnswer(
            (_) async => new http.StreamedResponse(
            new http.ByteStream.fromBytes(
                utf8.encode(responses.removeAt(0))
            ),
            200
        )
    );

    CalDavClient client = new CalDavClient('host', 'user', 'password', 'remote.php/caldav', port: 123, httpClient: httpMock);
    var response = await client.getCurrentUserPrincipal();
    expect(response, '/remote.php/caldav/principals/saitho/');
  });

  test('test getting user home calendar', () async {
    MockClient httpMock = new MockClient();

    List<String> responses = [data.nextCloudCurrentUser, data.nextCloudUserHomeCalendar];
    when(httpMock.send(any)).thenAnswer(
            (_) async => new http.StreamedResponse(
            new http.ByteStream.fromBytes(
                utf8.encode(responses.removeAt(0))
            ),
            200
        )
    );

    CalDavClient client = new CalDavClient('host', 'user', 'password', 'remote.php/caldav', port: 123, httpClient: httpMock);
    var response = await client.getUserHomeCalendar();
    expect(response, '/remote.php/caldav/calendars/saitho/');
  });
}
