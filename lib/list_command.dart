import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

const _namePrefix = 'repository_';

class ListCommand extends Command {
  @override
  final String name = 'list';

  @override
  final String description = 'Lists the stashed repository suffixes.';

  final M2Adapter _m2;
  final Outputter _outputter;

  ListCommand(this._m2, this._outputter);

  @override
  void run() {
    if (_m2.repositoryDir.existsSync()) {
      _outputter.out('(primary)');
    }
    
    _m2.m2Directory
        .listSync()
        .whereType<Directory>()
        .map((it) => p.basename(it.path))
        .where((name) => name.startsWith(_namePrefix))
        .map((name) => name.substring(name.indexOf('_') + 1))
        .forEach((name) => _outputter.out(name));
  }
}
