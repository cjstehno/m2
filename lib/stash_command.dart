import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

class StashCommand extends Command {
  @override
  final String name = 'stash';

  @override
  final String description = 'Renames the repository directory.';

  final M2Adapter _m2adapter;
  final Outputter _outputter;

  StashCommand(this._m2adapter, this._outputter);

  String get suffix =>
      argResults!.rest.isNotEmpty ? '_${argResults!.rest.first}' : '_stashed';

  @override
  void run() async {
    final stashName = 'repository$suffix';
    final newDirPath = p.join(_m2adapter.m2Path, stashName);

    if (!_m2adapter.repositoryDir.existsSync()) {
      _outputter.out('There is no repository directory to stash.');
    } else if (Directory(newDirPath).existsSync()) {
      _outputter.out('A stashed repository named "$stashName" already exists.');
    } else {
      await Directory(p.join(_m2adapter.m2Path, 'repository'))
          .rename(newDirPath);

      _outputter.out('Repository stashed as repository$suffix.');
    }
  }
}
