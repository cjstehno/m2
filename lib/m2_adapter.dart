import 'dart:io';

import 'package:path/path.dart' as p;

class M2Adapter {
  final String _homePath;

  const M2Adapter(this._homePath);

  String get m2Path => p.join(_homePath, '.m2');

  Directory get m2Directory => Directory(m2Path);

  Directory get repositoryDir => Directory(p.join(m2Path, 'repository'));
}
