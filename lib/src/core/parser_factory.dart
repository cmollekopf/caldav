import 'package:caldav/src/caldav/property/calendar-home-set.dart';
import 'package:caldav/src/core/parser.dart';
import 'package:caldav/src/webdav/element/_elements.dart';
import 'package:caldav/src/webdav/property/_properties.dart';

class ParserFactory {
  static final ParserFactory _instance = ParserFactory._internal();
  factory ParserFactory() => _instance;

  List<Parser> parsers = [];

  ParserFactory._internal() {
    this.parsers = [
      // WebDav Elements
      new PropParser(),
      new PropStatParser(),
      new ResponseParser(),
      new StatusParser(),

      // WebDav Properties
      new HrefParser(),
      new CurrentUserPrincipalParser(),
      new DisplayNameParser(),

      // CalDav Properties
      new CalendarHomeSetParser(),
    ];
  }

  Parser getParser(String name, String namespace) {
    return this.parsers.firstWhere((parser) =>
        parser.getNodeName() == name && parser.getNodeNamespace() == namespace);
  }
}
