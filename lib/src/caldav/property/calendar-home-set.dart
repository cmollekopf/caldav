import 'package:caldav/src/caldav/caldav_element.dart';
import 'package:caldav/src/caldav/caldav_parser.dart';
import 'package:xml/xml.dart';

class CalDavCalendarHomeSet extends CalDavElement {
  CalDavCalendarHomeSet() : super('calendar-home-set');

  String url;
}

class CalendarHomeSetParser extends CalDavParser<CalDavCalendarHomeSet> {
  @override
  CalDavCalendarHomeSet getGenericInstance() => new CalDavCalendarHomeSet();

  @override
  CalDavCalendarHomeSet parseSingle(XmlNode node) {
    var returnValue = new CalDavCalendarHomeSet();
    returnValue.url = this.parseChildren(node.children);
    return returnValue;
  }
}
