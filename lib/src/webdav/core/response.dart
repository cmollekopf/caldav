import '../element/response.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import '../parser/response.dart';

/// Internal object to serve WebDav responses. Not RFC related.
class Response {
  String requestPath;

  http.Response rawResponse;

  String rawBody;
  List<WebDavResponse> responses;

  Response(this.rawResponse, this.requestPath) {
    this.rawBody = this.rawResponse.body;
    var xmlDocument = xml.parse(this.rawBody);
    this.responses = new ResponseParser().parse(xmlDocument);
  }

  WebDavResponse getByPath(String remotePath) {
    return this.responses.firstWhere((response) => response.getHref() == getFullPath(remotePath));
  }

  WebDavResponse getByRequestPath() {
    return this.getByPath(this.requestPath);
  }

  List<WebDavResponse> getResponsesWithoutRequestHref() {
    var responses = this.responses;
    responses.removeWhere((response) => response.getHref() == getFullPath(this.requestPath));
    return responses;
  }

  /// Removes API base path and leading and trailing slash of path string
  String sanitizePath(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.startsWith(this.requestPath)) {
      path = path.substring(this.requestPath.length);
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.endsWith('/')) {
      path = path.substring(0, path.length-1);
    }
    return path;
  }

  String getFullPath(String remotePath) {
    remotePath = sanitizePath(remotePath);
    return '/' + this.requestPath + (remotePath.isNotEmpty ? '/' + remotePath : '') + '/';
  }
}