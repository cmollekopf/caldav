class StringUtility {
  /// Removes API base path and leading and trailing slash of path string
  static String sanitizePath(String path, {String baseUrl = ''}) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.startsWith(baseUrl)) {
      path = path.substring(baseUrl.length);
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  // /remote.php/caldav/principals/saitho/
  //

  static String getFullPath(String apiBase, String remotePath) {
    remotePath = StringUtility.sanitizePath(remotePath);
    return '/' +
        apiBase +
        (remotePath.isNotEmpty ? '/' + remotePath : '') +
        '/';
  }
}
