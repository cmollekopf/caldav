import 'package:caldav/src/caldav/property/calendar-home-set.dart';
import 'package:xml/src/xml/nodes/node.dart';

import '../caldav_parser.dart';

class CalendarHomeSetProcessor extends CalDavParser<CalDavCalendarHomeSet> {
  @override
  CalDavCalendarHomeSet getGenericInstance() => new CalDavCalendarHomeSet();

  @override
  CalDavCalendarHomeSet parseSingle(XmlNode node) {
    var returnValue = new CalDavCalendarHomeSet();
    returnValue.url = this.parseChildren(node.children);
    return returnValue;
  }
}