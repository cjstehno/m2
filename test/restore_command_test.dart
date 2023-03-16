import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/restore_command.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'stash_command_test.dart';
import 'temp_dir_provider.dart';
import 'test_outputter.dart';

void main() {
  late TestOutputter outputter;
  late CommandRunner runner;
  final homeDir = TempDirProvider('m2');

  setUp(() {
    homeDir.setUp();
    outputter = TestOutputter();

    runner = CommandRunner('m2', 'unit testing');
    runner.addCommand(RestoreCommand(M2Adapter(homeDir.path), outputter));
  });

  tearDown(() {
    homeDir.tearDown();
  });

  test('"m2 restore" with no stashed -> error', () async {
    await runner.run(['restore']);

    outputter.expects('No stashed repository "repository_stashed" exists.');
  });

  test('"m2 restore -s saved" with no stashed -> error', () async {
    await runner.run(['restore', 'saved']);

    outputter.expects('No stashed repository "repository_saved" exists.');
  });

  test('m2 restore with stashed results in restored', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository_stashed')).createSync(recursive: true);

    await runner.run(['restore']);

    outputter.expects('Maven repository_stashed restored.');

    expectDirectory(p.join(m2Path, 'repository_stashed'), false);
    expectDirectory(p.join(m2Path, 'repository'), true);
  });

  test('m2 restore with suffix - results in restored', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository_offline')).createSync(recursive: true);

    await runner.run(['restore', 'offline']);

    outputter.expects('Maven repository_offline restored.');

    expectDirectory(p.join(m2Path, 'repository_offline'), false);
    expectDirectory(p.join(m2Path, 'repository'), true);
  });

  test('m2 restore with existing - error', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository')).createSync(recursive: true);
    Directory(p.join(m2Path, 'repository_stashed')).createSync(recursive: true);

    await runner.run(['restore']);

    outputter
        .expects('Repository already exists, either delete or use --force.');

    expectDirectory(p.join(m2Path, 'repository_stashed'), true);
    expectDirectory(p.join(m2Path, 'repository'), true);
  });

  test('m2 restore with existing forced - succeeds', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository')).createSync(recursive: true);
    Directory(p.join(m2Path, 'repository_stashed')).createSync(recursive: true);

    await runner.run(['restore', '-f']);

    outputter.expects([
      'Deleting the existing repository directory...',
      'Maven repository_stashed restored.'
    ]);

    expectDirectory(p.join(m2Path, 'repository_stashed'), false);
    expectDirectory(p.join(m2Path, 'repository'), true);
  });
}
