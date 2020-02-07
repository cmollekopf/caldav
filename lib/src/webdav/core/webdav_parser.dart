import '../../core/parser.dart';

abstract class WebDavParser<T> extends Parser<T> {
  @override
  String getNodeNamespace() {
    return 'DAV:';
  }
}