/// internal object representing a CalDav calendar
class CalDavCalendar {
  /// path to calendar
  String path;

  /// name of calendar
  String displayName;

  /// Constructor
  CalDavCalendar(this.path, this.displayName);

  @override
  String toString() {
    return '$displayName (path: $path)';
  }
}
