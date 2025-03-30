part of '../env_reader.dart';

/// A function to add your [input] into .gitignore file in the same directory.
void insertGitignore({required ArgResults from}) {
  final bool insert = from['pubspec'];
  if (insert) {
    final gitignore = File('.gitignore');
    final input = from['input']!.toString();
    final output = from['output']?.toString();
    final lines = gitignore.readAsLinesSync();
    var inputExisted = false;
    var outputExisted = false;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains(input)) {
        inputExisted = true;
        break;
      }
    }

    if (output != null) {
      for (final item in lines) {
        if (item.contains(output)) {
          outputExisted = true;
          break;
        }
      }
    }

    if (!inputExisted) {
      const comment = '# Env Reader related';
      final index =
          lines.lastIndexWhere((line) => line.trim().startsWith(comment));
      if (index != -1) {
        lines.insert(index + 1, input);
      } else {
        lines.insert(0, '$comment\n$input');
      }
    }

    if (!outputExisted && output != null) {
      const comment = '# Env Reader related';
      final index =
          lines.lastIndexWhere((line) => line.trim().startsWith(comment));
      final export = outputExisted ? '' : output;
      if (index != -1) {
        lines.insert(index + 1, export);
      } else {
        lines.insert(0, '$comment\n$export');
      }
    }

    gitignore.writeAsStringSync(lines.join('\n'));
  }
}
