import 'package:m2/outputter.dart';
import 'package:test/expect.dart';

class TestOutputter implements Outputter {
  final List<String> lines = [];

  @override
  void out(final String line) {
    print(line);
    lines.add(line);
  }

  void expects(dynamic values) {
    if (values is String) {
      expect(lines.length, 1, reason: 'A single line was expected.');
      expect(
        lines[0],
        values,
        reason: 'The value ($values) does not match (${lines[0]}).',
      );
    } else if (values is List<String>) {
      expect(
        lines.length,
        values.length,
        reason: '${values.length} lines were expected - found ${values.length}',
      );

      for (var value in values) {
        expect(
          lines.contains(value),
          true,
          reason: 'The expected line ($value) was not found.',
        );
      }
    } else {
      throw Exception('The value type is not supported.');
    }
  }
}
