import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

class RepoRestoreCommand extends Command {
  static const _suffixOption = 'suffix';
  static const _defaultSuffix = 'stashed';
  static const _forceFlag = 'force';

  @override
  final String name = 'restore';

  @override
  final String description = 'Restores a stashed Maven repository.';

  final M2Adapter _m2adapter;
  final Outputter _outputter;

  RepoRestoreCommand(this._m2adapter, this._outputter) {
    argParser.addOption(
      _suffixOption,
      abbr: 's',
      help: 'Directory suffix to be used - defaults to "$_defaultSuffix".',
    );
  }

  String get suffix => argResults != null && argResults![_suffixOption] != null
      ? argResults![_suffixOption]
      : _defaultSuffix;

  bool get force => argResults != null && argResults![_forceFlag];

  @override
  void run() async {
    final stashedPath = p.join(_m2adapter.m2Path, 'repository_$suffix');
    final stashedDir = Directory(stashedPath);

    if (stashedDir.existsSync()) {
      final repoExists = _m2adapter.repositoryDir.existsSync();
      if (repoExists) {
        if (force) {
          _outputter.out('Deleting the existing repository directory...');
          // delete the existing repo dir
          _m2adapter.repositoryDir.deleteSync(recursive: true);
          // restore the stashed dir
          restore(stashedDir);
        } else {
          _outputter.out(
            'Maven repo already exists - either delete or use --force.',
          );
        }
      } else {
        restore(stashedDir);
      }
    } else {
      _outputter.out('No stashed repository "$stashedPath" exists.');
    }
  }

  void restore(final Directory stashedDir) async {
    await stashedDir.rename(_m2adapter.repositoryDir.path);
    _outputter.out('Maven repository_$suffix un-stashed.');
  }
}
