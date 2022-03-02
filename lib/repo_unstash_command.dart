import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:m2/repo_command.dart';

class RepoUnstashCommand extends RepoCommand {
  @override
  final String name = 'repo-unstash';

  @override
  final String description = 'Restores a stashed Maven repository.';

  RepoUnstashCommand() {
    argParser.addOption(
      'suffix',
      abbr: 's',
      help: 'Specifies directory suffix to be used - defaults to "stashed".',
    );
  }

  String get suffix => argResults != null && argResults!['suffix'] != null
      ? argResults!['suffix']
      : 'stashed';

  bool get force => argResults != null && argResults!['force'];

  @override
  void run() async {
    final homeDir = resolveHomeDir();

    if (homeDir != null) {
      final stashed = Directory(
        p.join(homeDir, '.m2', 'repository_$suffix'),
      );
      final repo = p.join(homeDir, '.m2', 'repository');

      final repoExists = await Directory(repo).exists();
      if (repoExists && force || !repoExists) {
        await stashed.rename(repo);
        print('Maven repository_$suffix un-stashed.');
      } else {
        print('Maven repo already exists - either delete or use --force.');
      }
    } else {
      print('The home directory could not be resolved.');
    }
  }
}
