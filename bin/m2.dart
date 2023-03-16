import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:m2/delete_command.dart';
import 'package:m2/find_command.dart';
import 'package:m2/list_command.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:m2/restore_command.dart';
import 'package:m2/stash_command.dart';
import 'package:m2/version_command.dart';

const _command = 'm2';
const _description = 'Maven local repository manager.';

void main(final List<String> arguments) {
  const outputter = Outputter();
  final m2Adapter = M2Adapter(_resolveHomePath());

  CommandRunner(_command, _description)
    ..addCommand(StashCommand(m2Adapter, outputter))
    ..addCommand(RestoreCommand(m2Adapter, outputter))
    ..addCommand(DeleteCommand(m2Adapter, outputter))
    ..addCommand(ListCommand(m2Adapter, outputter))
    ..addCommand(FindCommand(m2Adapter, outputter))
    ..addCommand(VersionCommand(outputter))
    ..run(arguments);
}

/// Retrieve the home directory for the user based on the platform.
String _resolveHomePath() {
  if (Platform.isMacOS || Platform.isLinux) {
    return Platform.environment['HOME']!;
  } else if (Platform.isWindows) {
    return Platform.environment['UserProfile']!;
  }
  throw Exception('Unable to determine home directory.');
}
