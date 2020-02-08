import '../webdav/element/prop.dart';

/// Creates new instances of objects passed as type into XmlElement<T> classes
class GenericsInitializer {
  static final Map<String, dynamic> _constructors = {
    'String': () => '',
    'List<WebDavProp>': () => new List<WebDavProp>(),
  };

  static T create<T>() {
    return _constructors[T.toString()]();
  }
}