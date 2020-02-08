import 'package:http/http.dart' as http;
import '../webdav/webdav.dart';
import './calendar.dart';
import '../webdav/core/webdav_element.dart';
import 'dart:developer' as developer;

class CalDavClient extends WebDavClient {
  CalDavClient(
      String host,
      String username,
      String password,
      String path,
      {String protocol = 'http', int port, http.BaseClient httpClient}
      ): super(host, username, password, path, protocol: protocol, port: port, httpClient: httpClient);


  Future<List<CalDavCalendar>> getCalendars(String calendarPath) async {
    String body = '''<x0:propfind xmlns:x0="DAV:">
  <x0:prop>
    <x0:displayname/>
    <x0:principal-collection-set/>
  </x0:prop>
</x0:propfind>''';
    var responseObj = await this.propfind(calendarPath, body: body);
    // Response object with href = this request does not have calendar information, remove it
    var responses = responseObj.getResponsesWithoutRequestHref();

    List<CalDavCalendar> list = [];
    responses.forEach((response) {
      var displayName = this.findProperty(response, new WebDavElement('displayname'));
      list.add(new CalDavCalendar(response.href, displayName.value.toString()));
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


    Response responseObj = await this
        .put(calendarPath + '/' + eventFileName + '.ics', body: calendarEntry);
    var response = responseObj.rawResponse;
    if (response.statusCode == 301) {
      return this.createCalendarEvent(
          response.headers['location']
      );
    }

    String xml = response.body;
    developer.log(xml);
  }
}