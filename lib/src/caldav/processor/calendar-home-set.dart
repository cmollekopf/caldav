import 'package:caldav/src/caldav/property/calendar-home-set.dart';
import 'package:xml/src/xml/nodes/node.dart';

import '../caldav_parser.dart';

class CalendarHomeSetProcessor extends CalDavParser<CalDavCalendarHomeSet> {
  @override
  String getNodeName() {
    return 'calendar-home-set';
  }

  @override
  CalDavCalendarHomeSet parseSingle(XmlNode node, {bool rescanNs = false}) {
    if (rescanNs) {
      this.updateNamespaces(node);
    }

    var returnValue = new CalDavCalendarHomeSet();
    returnValue.setValue(this.parseChildren(node.children));
    return returnValue;
  }
}