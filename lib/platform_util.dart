import 'dart:io';

class PlatformUtil {
  // FIXME: this can probably be put in the main starter

  /// Retrieve the home directory for the user based on the platform.
  String get homePath {
    if (Platform.isMacOS) {
      return Platform.environment['HOME']!;
    } else if (Platform.isLinux) {
      return Platform.environment['HOME']!;
    } else if (Platform.isWindows) {
      return Platform.environment['UserProfile']!;
    }
    throw Exception('Unable to determine home directory.');
  }
}
