class CalDavCalendar {
  String path;
  String displayName;

  CalDavCalendar(this.path, this.displayName);

  @override
  String toString() {
    return '$displayName (path: $path)';
  }
}