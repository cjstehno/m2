import 'package:args/command_runner.dart';
import 'package:m2/m2_adapter.dart';
import 'package:m2/outputter.dart';

// FIXME: test

class DeleteCommand extends Command {
  @override
  final String name = 'delete';

  @override
  final String description = 'Deletes your local Maven repository.';

  final M2Adapter _m2;
  final Outputter _outputter;

  DeleteCommand(this._m2, this._outputter);

  @override
  void run() async {
    final repoDir = _m2.repositoryDir;
    if (repoDir.existsSync()) {
      await repoDir.delete(recursive: true);
      _outputter.out('Deleted local Maven repository ($repoDir).');
    } else {
      _outputter.out('No local Maven repository directory found.');
    }
  }
}
