import 'dart:io';

import 'package:path/path.dart' as p;

class M2Adapter {
  final String _homePath;

  M2Adapter(this._homePath);

  String get m2Path {
    return p.join(_homePath, '.m2');
  }

  Directory get repositoryDir {
    return Directory(p.join(m2Path, 'repository'));
  }
}
