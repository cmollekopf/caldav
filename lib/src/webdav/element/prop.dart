import '../property/resourcetype.dart';

/// <prop> element described in RFC 4918
class WebDavProp {
  String name;
  String namespace;

  /// prop may have any value.
  /// Right now we expect it to be of type String or List<WebDavProp>
  // @todo: comply to requirement "This element MUST NOT contain text or mixed content."
  dynamic value;

  /// Subproperties may have a different namespace
  WebDavProp(this.name, {this.namespace = 'DAV:'});

  @override
  String toString() {
    return 'WebDavProp{name: $name, namespace: $namespace, value: ${value.toString()}';
  }

  @override
  bool operator ==(o) {
    return o is WebDavProp && name == o.name && namespace == o.namespace;
  }

  // @todo: check if needed / correct attempt to problem
  WebDavResourceType toWebDavResourceType() {
    return new WebDavResourceType(name, namespace: namespace);
  }
}