import 'package:caldav/src/core/utility/string.dart';
import 'package:caldav/src/core/xmlelement.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'dart:developer' as developer;
import '../element/_elements.dart';
import './response.dart';

class WebDavClient {
  String host;
  int port;
  String username;
  String password;
  String protocol;
  String path;
  String baseUrl;

  http_auth.BasicAuthClient concreteClient;

  WebDavClient(
      String host,
      String username,
      String password,
      String path,
      {String protocol = 'http', int port, http.BaseClient httpClient}
  ) {
    this.baseUrl = "$protocol://$host";
    if (port != null) {
      this.baseUrl = "$protocol://$host:$port";
    }

    // BaseURL must not end with /
    if (this.baseUrl.endsWith('"')) {
      this.baseUrl = this.baseUrl.substring(0, this.baseUrl.length-1);
    }

    this.path = path;
    if (this.path.isNotEmpty && this.path != '"') {
      this.baseUrl = [this.baseUrl, this.path].join('/');
    }

    this.concreteClient = new http_auth.BasicAuthClient(
        username,
        password,
        inner: httpClient
    );
  }

  String getUrl(String path) {
    path = path.trim();

    if (path.startsWith('/')) {
      path = path.substring(1, path.length);
    }

    return [this.baseUrl, path].join('/');
  }

  Future<Response> put(String remotePath, {String body, Map<String, String> headers}) async {
    remotePath = StringUtility.sanitizePath(remotePath, baseUrl: this.path);
    http.Response response = await this
        ._send('PUT', remotePath, headers: headers, body: body);
    return new Response(response, remotePath, this.path);
  }

  Future<Response> propfind(String remotePath, {String body}) async {
    remotePath = StringUtility.sanitizePath(remotePath, baseUrl: this.path);
    Map<String, String> userHeader = {'Depth': '1'};
    http.Response response = await this
        ._send('PROPFIND', remotePath, headers: userHeader, body: body);

    return new Response(response, remotePath, this.path);
  }

  /// send the actual HTTP request with given [method] and [path]
  Future<http.Response> _send(
      String method, String path, {String body, Map<String, String> headers}) async {
    String url = this.getUrl(path);
    var request = http.Request(method, Uri.parse(url));

    if (headers != null) request.headers.addAll(headers);
    if (body != null) {
      request.body = body;
    }

    developer.log("Connecting to $url");
    var response = await http.Response.fromStream(await this.concreteClient.send(request));
    if (response.statusCode == 301) {
      return this._send(method, response.headers['location'], body: body, headers: headers);
    }
    return response;
  }

  T findProperty<T extends XmlElement>(WebDavResponse response, T property, {bool ignoreNamespace = false}) {
    for (var propStat in response.propStats) {
      for (var prop in propStat.props) {
        for (var content in prop.content) {
          if ((!ignoreNamespace && content == property) || (ignoreNamespace && content.name == property.name)) {
            return content as T;
          }
        }
      }
    }
    return null;
  }
}