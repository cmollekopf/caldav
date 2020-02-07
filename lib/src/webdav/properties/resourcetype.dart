class WebDavResourceType {
  String name;
  String namespace;
  WebDavResourceType(this.name, {this.namespace = 'DAV:'});

  String toString() {
    return 'WebDavResourceType{name: $name, namespace: $namespace}';
  }

  String toXmlName() {
    return this.namespace + ':' + this.name;
  }
}