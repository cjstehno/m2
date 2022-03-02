import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/repo_stash_command.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'test_outputter.dart';

void main() {
  late TestOutputter outputter;
  late CommandRunner runner;
  late Directory homeDir;

  setUp(() {
    outputter = TestOutputter();
    homeDir = Directory(p.join(Directory.systemTemp.path, 'm2-test-home'));

    runner = CommandRunner('m2', 'unit testing');
    runner.addCommand(RepoStashCommand(M2Adapter(homeDir.path), outputter));
  });

  tearDown(() {
    if (homeDir.existsSync()) {
      homeDir.deleteSync(recursive: true);
    }
  });

  test('"m2 stash" with no repository -> error message', () async {
    await runner.run(['stash']);

    expect(outputter.lines.length, 1);
    expect(outputter.lines[0], 'There is no repository directory to stash.');
  });

  test('"m2 stash" with repository -> repository_stashed', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository')).createSync(recursive: true);

    await runner.run(['stash']);

    expect(outputter.lines.length, 1);
    expect(outputter.lines[0], 'Repository stashed as repository_stashed.');

    _expectDirectory(p.join(m2Path, 'repository_stashed'), true);
    _expectDirectory(p.join(m2Path, 'repository'), false);
  });

  test('"m2 stash -s foo" with repository -> repository_foo', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository')).createSync(recursive: true);

    await runner.run(['stash', '-s', 'foo']);

    expect(outputter.lines.length, 1);
    expect(outputter.lines[0], 'Repository stashed as repository_foo.');

    _expectDirectory(p.join(m2Path, 'repository_foo'), true);
    _expectDirectory(p.join(m2Path, 'repository_stashed'), false);
    _expectDirectory(p.join(m2Path, 'repository'), false);
  });

  test('"m2 stash" with repository stashed -> error message', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository')).createSync(recursive: true);
    Directory(p.join(m2Path, 'repository_stashed')).createSync(recursive: true);

    await runner.run(['stash']);

    expect(outputter.lines.length, 1);
    expect(
      outputter.lines[0],
      'A stashed repository named "repository_stashed" already exists.',
    );
  });
}

void _expectDirectory(final String path, final bool exists) {
  expect(
    Directory(path).existsSync(),
    exists,
    reason: 'Directory ($path) should ${exists ? '' : 'NOT '}exist.',
  );
}
