import 'package:args/command_runner.dart';
import 'package:m2/outputter.dart';

class VersionCommand extends Command {
  @override
  final String name = 'version';

  @override
  final String description = 'Displays the version information.';

  final Outputter _outputter;

  VersionCommand(this._outputter);

  @override
  void run() => _outputter.out('v1.0.0');
}
