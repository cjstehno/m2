import 'dart:io';

import 'package:path/path.dart' as p;

class M2Adapter {
  final String m2Path;
  final Directory m2Directory;
  final Directory repositoryDir;

  M2Adapter._(this.m2Path, this.m2Directory, this.repositoryDir);

  factory M2Adapter(final String homePath) {
    final m2Path = p.join(homePath, '.m2');
    return M2Adapter._(
      m2Path,
      Directory(m2Path),
      Directory(p.join(m2Path, 'repository')),
    );
  }
}
