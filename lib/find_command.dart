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
    argParser.addOption(
      _groupOption,
      abbr: 'g',
      help:
          'The group to be searched (may be partial leading in dot-notation).',
    );
  }

  String? get suffix => argResults != null && argResults![_suffixOption] != null
      ? argResults![_suffixOption]
      : null;

  String? get group => argResults != null && argResults![_groupOption] != null
      ? argResults![_groupOption]
      : null;

  String get jar => argResults!.rest.isNotEmpty ? argResults!.rest.first : '';

  @override
  void run() {
    final dirName = suffix != null ? 'repository_$suffix' : 'repository';
    final repoDir = Directory(p.join(_m2.m2Path, dirName));

    if (repoDir.existsSync()) {
      _applyGroupDir(repoDir)
          .listSync(recursive: true)
          .whereType<File>()
          .map((it) => it.path)
          .where((pth) => pth.endsWith('.jar'))
          .where((pth) => !pth.endsWith('-sources.jar'))
          .where((pth) => !pth.contains('SNAPSHOT'))
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
      _fileName(path).toLowerCase().contains(jar.toLowerCase());

  void _printJar(final Directory repoDir, final String path) {
    final jarName = _fileName(path);
    final jarVersion = _jarVersion(path);
    final jarGroup = _jarGroup(repoDir.path, path, jarName);

    // TODO: better way of formatting
    _outputter.out(
      "${jarGroup.padRight(70)}${jarName.padRight(35)}\t$jarVersion",
    );
  }

  static String _fileName(final String path) =>
      path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf("-"));

  static String _jarVersion(final String path) =>
      path.substring(path.lastIndexOf('-') + 1, path.lastIndexOf('.'));

  static String _jarGroup(
    final String repoPath,
    final String path,
    final String jarName,
  ) {
    final localPath = path.replaceFirst(repoPath, '');
    return localPath
        .substring(1, localPath.indexOf(jarName) + jarName.length)
        .replaceAll('/', '.');
  }
}
