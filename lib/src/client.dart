import 'package:caldav/src/xml/webdavresponse_parser.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'dart:developer' as developer;

import './objects.dart';

class WebDavException implements Exception {
  String cause;

  WebDavException(this.cause);
}

class CalDavClient extends http_auth.BasicAuthClient {
  String host;
  int port;
  String username;
  String password;
  String protocol;
  String path;
  String baseUrl;

  CalDavClient(
      String host,
      String username,
      String password,
      String path,
      {String protocol = 'http', int port, http.BaseClient httpClient}
  ): super(username, password, inner: httpClient) {
    this.baseUrl = "$protocol://$host";
    if (port != null) {
      this.baseUrl = "$protocol://$host:$port";
    }

    // BaseURL must not end with /
    if (this.baseUrl.endsWith('"')) {
      this.baseUrl = this.baseUrl.substring(0, this.baseUrl.length-1);
    }

    this.path = path;
    if (this.path.isNotEmpty && this.path != '"') {
      this.baseUrl = [this.baseUrl, this.path].join('/');
    }
  }

  String getUrl(String path) {
    path = path.trim();

    if (path.startsWith('/')) {
      path = path.substring(1, path.length);
    }

    return [this.baseUrl, path].join('/');
  }

  /// send the request with given [method] and [path]
  Future<http.Response> _send(
      String method, String path, {String body, Map<String, String> headers}) async {
    String url = this.getUrl(path);
    var request = http.Request(method, Uri.parse(url));

    if (headers != null) request.headers.addAll(headers);
    if (body != null) {
      request.body = body;
    }

    developer.log("Connecting to $url");
    return http.Response.fromStream(await this.send(request));
  }

  /// @deprecated Use getWebDavResponse instead
  Future<List<WebDavResponse>> getWebDavResponses(String remotePath, {String body, method = 'PROPFIND'}) async {
    remotePath = sanitizePath(remotePath);
    Map<String, String> userHeader = {'Depth': '1'};
    http.Response response = await this
        ._send(method, remotePath, headers: userHeader, body: body);
    if (response.statusCode == 301) {
      return this.getWebDavResponses(response.headers['location'], body: body, method: method);
    }

    var xmlDocument = xml.parse(response.body);
    return new WebDavResponseParser().parse(xmlDocument);
  }

  Future<WebDavResponse> getWebDavResponse(String remotePath, {String body, method = 'PROPFIND'}) async {
    remotePath = sanitizePath(remotePath);
    var responses = await this.getWebDavResponses(remotePath, body: body, method: method);
    return responses.firstWhere((response) => response.href == getFullPath(remotePath));
  }

  /// Removes API base path and leading and trailing slash of path string
  String sanitizePath(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.startsWith(this.path)) {
      path = path.substring(this.path.length);
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.endsWith('/')) {
      path = path.substring(0, path.length-1);
    }
    return path;
  }

  String getFullPath(String remotePath) {
    remotePath = sanitizePath(remotePath);
    return '/' + this.path + (remotePath.isNotEmpty ? '/' + remotePath : '') + '/';
  }

  WebDavProp findProperty(WebDavResponse response, WebDavProp property, {bool ignoreNamespace = false}) {
    for (var propStat in response.propStats) {
      for (var prop in propStat.props) {
        if ((!ignoreNamespace && prop == property) || (ignoreNamespace && prop.name == property.name)) {
          return prop;
        }
      }
    }
  }

  Future<List<WebDavCalendar>> getCalendars(String calendarPath, {String filter = ""}) async {
    String body = '''<D:propfind xmlns:D="DAV:">
  <D:prop>
    <D:displayname/>
    <D:principal-collection-set/>
    {$filter}
  </D:prop>
</D:propfind>''';
    var responses = await this.getWebDavResponses(calendarPath, body: body);
    // Response object with href = this request does not have calendar information, remove it
    responses.removeWhere((response) => response.href == getFullPath(calendarPath));

    List<WebDavCalendar> list = [];
    responses.forEach((response) {
      var displayName = this.findProperty(response, new WebDavProp('displayname'));
      list.add(new WebDavCalendar(response.href, displayName.value.toString()));
    });

    return list;
  }

  Future<List<WebDavCalendar>> getTodoCalendars(String calendarPath) async {
    String filter = '''
    <C:supported-calendar-component-set xmlns:C="urn:ietf:params:xml:ns:caldav">
           <C:comp name="VTODO"/>
    </C:supported-calendar-component-set>''';
    return getCalendars(calendarPath, filter: filter);
  }

  Future<List<WebDavEntry>> getEntries(String calendarPath) async {
    String body = '''<C:calendar-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav">
  <D:prop>
    <D:getetag/>
    <C:calendar-data>
      <C:comp name="VCALENDAR">
        <C:prop name="VERSION"/>
        <C:comp name="VTODO">
          <C:prop name="SUMMARY"/>
          <C:prop name="UID"/>
          <C:prop name="DTSTART"/>
          <C:prop name="DTEND"/>
          <C:prop name="DURATION"/>
          <C:prop name="COMPLETED"/>
        </C:comp>
        <C:comp name="VTIMEZONE"/>
      </C:comp>
    </C:calendar-data>
  </D:prop>
  <C:filter>
      <C:comp-filter name="VCALENDAR">
        <C:comp-filter name="VTODO" />

      </C:comp-filter>
  </C:filter>
</C:calendar-query>''';
    print("get entries " + calendarPath);
    var responses = await this.getWebDavResponses(calendarPath, body: body, method: 'REPORT');

    List<WebDavEntry> list = [];
    responses.forEach((response) {
      var data = this.findProperty(response, new WebDavProp('calendar-data'), ignoreNamespace: true);
      var etag = this.findProperty(response, new WebDavProp('getetag'), ignoreNamespace: true);
      list.add(new WebDavEntry(response.href, etag.value.toString(), data.value.toString()));
    });

    return list;
  }

  void createCalendarEvent(String calendarPath) async {
    if (calendarPath.startsWith('/' + this.path)) {
      calendarPath = calendarPath.substring(this.path.length + 1);
    }

    String eventFileName = 'event-' + new DateTime.now().millisecondsSinceEpoch.toString();
    String calendarEntry = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Example Corp.//CalDAV Client//EN
BEGIN:VEVENT
UID:20010712T182145Z-123401@example.com
DTSTAMP:20200212T182145Z
DTSTART:20200214T170000Z
DTEND:20200215T040000Z
SUMMARY:Test Event
END:VEVENT
END:VCALENDAR''';


    http.Response response = await this
        ._send('PUT', calendarPath + '/' + eventFileName + '.ics', body: calendarEntry, headers: {'Depth': '1'});
    if (response.statusCode == 301) {
      return this.createCalendarEvent(
          response.headers['location']
      );
    }

    String xml = response.body;
    developer.log(xml);
  }

  void updateEntry(String entryPath, calendarEntry) async {
    if (entryPath.startsWith('/' + this.path)) {
      entryPath = entryPath.substring(this.path.length + 1);
    }

    http.Response response = await this
        ._send('PUT', entryPath, body: calendarEntry, headers: {'Depth': '1'});
    if (response.statusCode == 301) {
      return this.updateEntry(
          response.headers['location'], calendarEntry
      );
    }

    String xml = response.body;
    developer.log(xml);
  }


  //FIXME this is the same as updateEntry
  void addEntry(String entryPath, calendarEntry) async {
    if (entryPath.startsWith('/' + this.path)) {
      entryPath = entryPath.substring(this.path.length + 1);
    }

    http.Response response = await this
        ._send('PUT', entryPath, body: calendarEntry, headers: {'Depth': '1'});
    if (response.statusCode == 301) {
      return this.addEntry(
          response.headers['location'], calendarEntry
      );
    }

    String xml = response.body;
    developer.log(xml);
  }

}