import 'package:caldav/src/core/utility/string.dart';

import 'element/response.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

/// Internal object to serve WebDav responses. Not RFC related.
class Response {
  String
      requestPath; // Request path in http://[baseurl]/[apiPath]/[requestpath], e.g. "calendar" in http://baseurl.com/api/calendar
  String
      requestApiPath; // apiPath in http://[baseurl]/[apiPath]/[requestPath], e.g. "api" in http://baseurl.com/api/calendar

  http.Response rawResponse;

  String rawBody;
  List<WebDavResponse> responses;

  Response(this.rawResponse, this.requestPath, this.requestApiPath) {
    this.rawBody = this.rawResponse.body;
    var xmlDocument = xml.parse(this.rawBody);
    this.responses = new ResponseParser().parse(xmlDocument);
  }

  WebDavResponse getByPath(String remotePath) {
    return this.responses.firstWhere((response) =>
        response.getHref() ==
        StringUtility.getFullPath(this.requestApiPath, remotePath));
  }

  WebDavResponse getByRequestPath() {
    return this.getByPath(this.requestPath);
  }

  List<WebDavResponse> getResponsesWithoutRequestHref() {
    var responses = this.responses;
    responses.removeWhere((response) =>
        response.getHref() ==
        StringUtility.getFullPath(this.requestApiPath, this.requestPath));
    return responses;
  }
}
