import '../property/resourcetype.dart';

class DavResource {
  WebDavResourceType resourceType;
  String path;

  DavResource(this.path, this.resourceType);

  @override
  String toString() {
    return 'WebDavResource{path: $path, resourceType: $resourceType}';
  }
}