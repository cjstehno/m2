import 'dart:io';

import 'package:args/command_runner.dart';

abstract class RepoCommand extends Command {
  String? resolveHomeDir() {
    final os = Platform.operatingSystem;
    String? home;
    Map<String, String> envVars = Platform.environment;
    if (Platform.isMacOS) {
      home = envVars['HOME'];
    } else if (Platform.isLinux) {
      home = envVars['HOME'];
    } else if (Platform.isWindows) {
      home = envVars['UserProfile'];
    }
    return home;
  }
}
