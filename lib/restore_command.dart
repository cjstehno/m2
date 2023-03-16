import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

const _forceFlag = 'force';

class RestoreCommand extends Command {
  @override
  final String name = 'restore';

  @override
  final String description = 'Restores a stashed repository.';

  final M2Adapter _m2adapter;
  final Outputter _outputter;

  RestoreCommand(this._m2adapter, this._outputter) {
    argParser.addFlag(
      _forceFlag,
      abbr: 'f',
      help: 'Forces the existing repository to be overwritten.',
    );
  }

  String get suffix =>
      argResults!.rest.isNotEmpty ? '_${argResults!.rest.first}' : '_stashed';

  bool get force => argResults != null && argResults![_forceFlag];

  @override
  void run() async {
    final stashedName = 'repository$suffix';
    final stashedDir = Directory(p.join(_m2adapter.m2Path, stashedName));

    if (stashedDir.existsSync()) {
      if (_m2adapter.repositoryDir.existsSync()) {
        if (force) {
          _outputter.out('Deleting the existing repository directory...');
          // delete the existing repo dir
          _m2adapter.repositoryDir.deleteSync(recursive: true);
          // restore the stashed dir
          await restore(stashedDir);
        } else {
          _outputter.out(
            'Repository already exists, either delete or use --force.',
          );
        }
      } else {
        await restore(stashedDir);
      }
    } else {
      _outputter.out('No stashed repository "$stashedName" exists.');
    }
  }

  Future<void> restore(final Directory stashedDir) async {
    await stashedDir.rename(_m2adapter.repositoryDir.path);
    _outputter.out('Maven repository$suffix restored.');
  }
}
