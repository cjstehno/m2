import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:m2/repo_command.dart';

class RepoDeleteCommand extends RepoCommand {
  @override
  final String name = 'repo-delete';

  @override
  final String description = 'Deletes your local Maven repository.';

  void run() async {
    final homeDir = resolveHomeDir();
    if (homeDir != null) {
      final repoDir = Directory(p.join(homeDir, '.m2', 'repository'));
      if (repoDir.existsSync()) {
        await repoDir.delete(recursive: true);
        print('Deleted local Maven repository ($repoDir).');
      }
    } else {
      print('The home directory could not be resolved.');
    }
  }
}
