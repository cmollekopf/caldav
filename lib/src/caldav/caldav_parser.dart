import '../webdav/core/webdav_parser.dart';
import 'caldav_element.dart';

abstract class CalDavParser<T> extends WebDavParser<T> {
  @override
  String getNodeNamespace() {
    return calDavNamespace;
  }
}