import 'package:m2/outputter.dart';

class TestOutputter implements Outputter {
  final List<String> lines = [];

  @override
  void out(final String line) {
    lines.add(line);
  }
}
