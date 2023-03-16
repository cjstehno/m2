import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

const _suffixOption = 'suffix';

class DeleteCommand extends Command {
  @override
  final String name = 'delete';

  @override
  final String description = 'Deletes a repository (primary by default).';

  final M2Adapter _m2;
  final Outputter _outputter;

  DeleteCommand(this._m2, this._outputter) {
    argParser.addOption(
      _suffixOption,
      abbr: 's',
      help: 'Directory name suffix (defaults to the primary repository)',
    );
  }

  String? get suffix => argResults != null && argResults![_suffixOption] != null
      ? argResults![_suffixOption]
      : null;

  @override
  void run() async {
    final dirName = suffix != null ? 'repository_$suffix' : 'repository';
    final repoDir = Directory(p.join(_m2.m2Path, dirName));

    if (repoDir.existsSync()) {
      await repoDir.delete(recursive: true);
      _outputter.out('Deleted "$dirName".');
    } else {
      _outputter.out('Repository "$dirName" does not exist.');
    }
  }
}
