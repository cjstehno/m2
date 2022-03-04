import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:random_string/random_string.dart';

class TempDirProvider {
  final String _rootName;
  late Directory directory;

  TempDirProvider(this._rootName);

  String get path => directory.path;

  void setUp() {
    directory = Directory(p.join(
      Directory.systemTemp.path,
      _rootName,
      randomAlphaNumeric(12),
    ));
  }

  void tearDown() {
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  }
}
