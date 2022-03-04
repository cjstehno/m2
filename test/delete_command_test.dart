import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/delete_command.dart';
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
    runner.addCommand(DeleteCommand(M2Adapter(homeDir.path), outputter));
  });

  tearDown(() => homeDir.tearDown());

  test('delete with no repository - message', () async {
    await runner.run(['delete']);

    outputter.expects('No local Maven repository directory found.');
  });

  test('delete no repository - succeeds', () async {
    // create a repo dir
    final m2Path = p.join(homeDir.path, '.m2');
    Directory(p.join(m2Path, 'repository')).createSync(recursive: true);

    await runner.run(['delete']);

    outputter.expects('Deleted local Maven repository.');
  });
}
