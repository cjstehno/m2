import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

class DeleteCommand extends Command {
  @override
  final String name = 'delete';

  @override
  final String description = 'Deletes a repository (primary by default).';

  final M2Adapter _m2;
  final Outputter _outputter;

  DeleteCommand(this._m2, this._outputter);

  String get suffix =>
      argResults!.rest.isNotEmpty ? '_${argResults!.rest.first}' : '';

  // TODO: add a confirmation step?

  @override
  void run() async {
    final dirName = 'repository$suffix';
    final repoDir = Directory(p.join(_m2.m2Path, dirName));

    if (repoDir.existsSync()) {
      await repoDir.delete(recursive: true);
      _outputter.out('Deleted "$dirName".');
    } else {
      _outputter.out('Repository "$dirName" does not exist.');
    }
  }
}
