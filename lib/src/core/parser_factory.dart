import 'package:caldav/src/core/parser.dart';
import 'package:caldav/src/webdav/parser/displayname.dart';
import 'package:caldav/src/webdav/parser/status.dart';
import 'package:caldav/src/webdav/parser/prop.dart';
import 'package:caldav/src/webdav/parser/propstat.dart';
import 'package:caldav/src/webdav/parser/href.dart';
import 'package:caldav/src/webdav/parser/response.dart';
import 'package:caldav/src/webdav/parser/current-user-principal.dart';
import 'package:caldav/src/caldav/processor/calendar-home-set.dart';

class ParserFactory {
  static final ParserFactory _instance = ParserFactory._internal();
  factory ParserFactory() => _instance;

  List<Parser> parsers = [];

  ParserFactory._internal() {
    this.parsers = [
      // WebDav
      new PropParser(),
      new HrefParser(),
      new PropStatParser(),
      new ResponseParser(),
      new StatusParser(),
      new CurrentUserPrincipalParser(),
      new DisplayNameParser(),

      // CalDav
      new CalendarHomeSetProcessor(),
    ];
  }

  Parser getParser(String name, String namespace) {
    return this.parsers.firstWhere((parser) => parser.getNodeName() == name && parser.getNodeNamespace() == namespace);
  }
}