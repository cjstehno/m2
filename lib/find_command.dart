import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:path/path.dart' as p;

const _suffixOption = 'suffix';
const _groupOption = 'group';
const _jarOption = 'jar';

class FindCommand extends Command {
  @override
  final String name = 'find';

  @override
  final String description =
      'Finds repository artifacts matching the given name.';

  final M2Adapter _m2;
  final Outputter _outputter;

  FindCommand(this._m2, this._outputter) {
    argParser.addOption(
      _suffixOption,
      abbr: 's',
      help: 'Repository name suffix (defaults to the primary repository).',
    );
    argParser.addOption(_groupOption,
        abbr: 'g',
        help:
            'The group to be searched (may be partial leading in dot-notation).');
    argParser.addOption('jar',
        abbr: 'j', help: 'The jar name pattern (case-insensitive contains).');
  }

  String? get suffix => argResults != null && argResults![_suffixOption] != null
      ? argResults![_suffixOption]
      : null;

  String? get group => argResults != null && argResults![_groupOption] != null
      ? argResults![_groupOption]
      : null;

  // fIXME: should be required
  String? get jar => argResults != null && argResults![_jarOption] != null
      ? argResults![_jarOption]
      : null;

  @override
  void run() {
    final dirName = suffix != null ? 'repository_$suffix' : 'repository';
    final repoDir = Directory(p.join(_m2.m2Path, dirName));

    if (repoDir.existsSync()) {
      // navigate down to the group prefix (if given)
      final Directory searchedDir = _applyGroupDir(repoDir);

      // FIXME: find matching jars under searched dir
      searchedDir
          .listSync(recursive: true)
          .whereType<File>()
          .map((it) => it.path)
          .where((pth) => pth.endsWith('.jar'))
          .where((pth) => _filenameMatches(pth))
          .forEach((pth) => _printJar(repoDir, pth));
    } else {
      _outputter.out('Repository "$dirName" does not exist.');
    }
  }

  // If no group prefix is specified, return the repo dir
  Directory _applyGroupDir(final Directory repoDir) => group != null
      ? Directory(p.join(repoDir.path, group!.replaceAll('.', '/')))
      : repoDir;

  bool _filenameMatches(final String path) =>
      _fileName(path).toLowerCase().contains(jar!.toLowerCase());

  void _printJar(final Directory repoDir, final String path) {
    // /Users/stehnoc/.m2/repository/org/apache/zookeeper/zookeeper-jute/3.7.0/zookeeper-jute-3.7.0.jar
    final jarName = _fileName(path);
    final jarVersion =
        path.substring(path.lastIndexOf('-') + 1, path.lastIndexOf('.'));

    final localPath = path.replaceFirst(repoDir.path, '');
    final jarGroup = localPath.substring(1, localPath.indexOf(jarName) + jarName.length ).replaceAll('/', '.');

    _outputter.out("${jarGroup.padRight(65)}${jarName.padRight(30)}\t$jarVersion");
  }

  static String _fileName(final String path) =>
      path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf("-"));
}
