import 'package:args/command_runner.dart';
import 'package:m2/delete_command.dart';
import 'package:m2/list_command.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:m2/platform_util.dart';
import 'package:m2/restore_command.dart';
import 'package:m2/stash_command.dart';
import 'package:m2/version_command.dart';

void main(final List<String> arguments) {
  final runner = CommandRunner(
    'm2',
    'Maven local repository manager.',
  );

  final outputter = Outputter();
  final m2Adapter = M2Adapter(PlatformUtil().homePath);

  runner.addCommand(StashCommand(m2Adapter, outputter));
  runner.addCommand(RestoreCommand(m2Adapter, outputter));
  runner.addCommand(DeleteCommand(m2Adapter, outputter));
  runner.addCommand(ListCommand(m2Adapter, outputter));
  runner.addCommand(VersionCommand(outputter));

  runner.run(arguments);
}
