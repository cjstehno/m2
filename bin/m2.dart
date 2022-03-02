import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';
import 'package:m2/platform_util.dart';
import 'package:m2/repo_delete_command.dart';
import 'package:m2/repo_stash_command.dart';
import 'package:m2/repo_unstash_command.dart';


void main(final List<String> arguments) {
  final runner = CommandRunner(
    'scm',
    'A helper to round out the rough edges imposed by SCM.',
  );

  final outputter = Outputter();
  final m2Adapter = M2Adapter(PlatformUtil().homePath);

  runner.addCommand(RepoStashCommand(m2Adapter, outputter));
  runner.addCommand(RepoUnstashCommand());
  runner.addCommand(RepoDeleteCommand());

  runner.run(arguments);
}
