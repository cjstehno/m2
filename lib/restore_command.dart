import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

class RestoreCommand extends Command {
  static const _suffixOption = 'suffix';
  static const _defaultSuffix = 'stashed';
  static const _forceFlag = 'force';

  @override
  final String name = 'restore';

  @override
  final String description = 'Restores a stashed Maven repository.';

  final M2Adapter _m2adapter;
  final Outputter _outputter;

  RestoreCommand(this._m2adapter, this._outputter) {
    argParser.addOption(
      _suffixOption,
      abbr: 's',
      help: 'Repository suffix to be used - defaults to "$_defaultSuffix".',
    );
    argParser.addFlag(
      _forceFlag,
      abbr: 'f',
      help: 'Forces the existing repository to be overwritten.',
    );
  }

  String get suffix => argResults != null && argResults![_suffixOption] != null
      ? argResults![_suffixOption]
      : _defaultSuffix;

  bool get force => argResults != null && argResults![_forceFlag];

  @override
  void run() async {
    final stashedName = 'repository_$suffix';
    final stashedPath = p.join(_m2adapter.m2Path, stashedName);
    final stashedDir = Directory(stashedPath);

    if (stashedDir.existsSync()) {
      final repoExists = _m2adapter.repositoryDir.existsSync();
      if (repoExists) {
        if (force) {
          _outputter.out('Deleting the existing repository directory...');
          // delete the existing repo dir
          _m2adapter.repositoryDir.deleteSync(recursive: true);
          // restore the stashed dir
          await restore(stashedDir);
        } else {
          _outputter.out(
            'Repository already exists - either delete or use --force.',
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
    _outputter.out('Maven repository_$suffix restored.');
  }
}
