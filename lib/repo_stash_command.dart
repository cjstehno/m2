import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

// FIXME: error if stash dir already exists
// fIXME: testing

class RepoStashCommand extends Command {
  static const _suffix_option = 'suffix';
  static const _default_suffix = 'stashed';

  @override
  final String name = 'stash';

  @override
  final String description = 'Renames the Maven repository directory.';

  final M2Adapter m2adapter;
  final Outputter outputter;

  RepoStashCommand(this.m2adapter, this.outputter) {
    argParser.addOption(
      _suffix_option,
      abbr: 's',
      help: 'Specifies directory name suffix - defaults to "$_default_suffix".',
    );
  }

  String get suffix => argResults != null && argResults![_suffix_option] != null
      ? argResults![_suffix_option]
      : _default_suffix;

  @override
  void run() async {
    final stashName = 'repository_$suffix';
    final newDirPath = p.join(m2adapter.m2Path, stashName);

    if (!m2adapter.repositoryDir.existsSync()) {
      outputter.out('There is no repository directory to stash.');
    } else if (Directory(newDirPath).existsSync()) {
      outputter.out('A stashed repository named "$stashName" already exists.');
    } else {
      await Directory(p.join(m2adapter.m2Path, 'repository'))
          .rename(newDirPath);

      outputter.out('Repository stashed as repository_$suffix.');
    }
  }
}
