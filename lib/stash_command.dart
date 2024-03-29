import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/io.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

const _deleteFlag = 'delete';

class StashCommand extends Command {
  @override
  final String name = 'stash';

  @override
  final String description = 'Renames the repository directory.';

  final M2Adapter _m2adapter;
  final Outputter _outputter;

  StashCommand(this._m2adapter, this._outputter) {
    argParser.addFlag(
      _deleteFlag,
      defaultsTo: true,
      help: 'Deletes the original repository after stashing.',
    );
  }

  String get suffix =>
      argResults!.rest.isNotEmpty ? '_${argResults!.rest.first}' : '_stashed';

  bool get delete => argResults != null && argResults![_deleteFlag];

  @override
  void run() async {
    final stashName = 'repository$suffix';
    final newDirPath = p.join(_m2adapter.m2Path, stashName);

    if (!_m2adapter.repositoryDir.existsSync()) {
      _outputter.out('There is no repository directory to stash.');
    } else if (Directory(newDirPath).existsSync()) {
      _outputter.out('A stashed repository named "$stashName" already exists.');
    } else {
      final repoPath = p.join(_m2adapter.m2Path, 'repository');

      if (delete) {
        await Directory(repoPath).rename(newDirPath);
      } else {
        copyPathSync(repoPath, newDirPath);
      }

      _outputter.out(
        'Repository stashed as repository$suffix.${delete ? ' The original repository was not deleted.' : ''}',
      );
    }
  }
}
