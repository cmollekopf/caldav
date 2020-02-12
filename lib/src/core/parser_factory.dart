import '../caldav/property/calendar_home_set.dart';
import '../webdav/element/_elements.dart';
import '../webdav/property/_properties.dart';
import 'parser.dart';

/// Used for finding the parser for a XMl element
class ParserFactory {
  static final ParserFactory _instance = ParserFactory._internal();
  /// Creates a singleton [ParserFactory] instance
  factory ParserFactory() => _instance;

  /// List of registered parsers
  List<Parser> parsers;

  ParserFactory._internal() {
    parsers = [
      // WebDav Elements
      PropParser(),
      PropStatParser(),
      ResponseParser(),
      StatusParser(),

      // WebDav Properties
      HrefParser(),
      CurrentUserPrincipalParser(),
      DisplayNameParser(),

      // CalDav Properties
      CalendarHomeSetParser(),
    ];
  }

  /// Returns a [Parser] for the XML object identified by [name] and [namespace]
  Parser getParser(String name, String namespace) {
    return parsers.firstWhere((parser) =>
        parser.nodeName == name && parser.nodeNamespace == namespace);
  }
}
