import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/list_command.dart';
import 'package:m2/m2_adapter.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

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
    runner.addCommand(ListCommand(M2Adapter(homeDir.path), outputter));
  });

  tearDown(() => homeDir.tearDown());

  test('list with stashed', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository')).createSync(recursive: true);
    Directory(p.join(m2Path, 'repository_alpha')).createSync(recursive: true);
    Directory(p.join(m2Path, 'repository_stashed')).createSync(recursive: true);

    await runner.run(['list']);

    outputter.expects([
      '(primary)',
      'alpha',
      'stashed',
    ]);
  });

  test('list with stashed without primary', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository_alpha')).createSync(recursive: true);
    Directory(p.join(m2Path, 'repository_stashed')).createSync(recursive: true);

    await runner.run(['list']);

    outputter.expects([
      'alpha',
      'stashed',
    ]);
  });
}
