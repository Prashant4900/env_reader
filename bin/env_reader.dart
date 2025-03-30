import 'dart:io';

import 'package:args/args.dart';
import 'package:env_reader/src/env_encryption.dart';

part 'src/file.dart';
part 'src/gitignore.dart';
part 'src/json.dart';
part 'src/pubspec.dart';

/// Dart runner for `EnvReader` library.
void main(List<String> arguments) async {
  final runner = ArgParser()
    ..addOption(
      'input',
      abbr: 'i',
      help: 'Input path of the .env file',
      mandatory: true,
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: 'Output path for the encrypted .env file',
    )
    ..addOption(
      'key',
      abbr: 's',
      help: 'Secret key for encryption & decryption',
    )
    ..addOption('model', help: 'Generate dart model to your desired file path')
    ..addFlag(
      'null-safety',
      negatable: false,
      help: 'Make the model null safety',
    )
    ..addFlag(
      'obfuscate',
      defaultsTo: true,
      help: 'Obfuscating generated values of model',
    )
    ..addFlag(
      'pubspec',
      defaultsTo: true,
      help: 'Inserting asset path to pubspec.yaml',
    )
    ..addFlag(
      'gitignore',
      defaultsTo: true,
      help: 'Inserting .env input & output file into .gitignore',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information',
    );
  try {
    final argument = runner.parse(arguments);
    if (argument['help']) {
      throw '\u001b[0mAvailable commands:';
    } else {
      insertJson(from: argument);
      insertPubspec(from: argument);
      insertGitignore(from: argument);
      insertFile(from: argument);
    }
  } catch (e) {
    print('\n\u001b[31m$e\u001b[0m\n');
    print(runner.usage);
    print('\n\u001b[32mdart run\u001b[0m '
        '\u001b[36menv_reader\u001b[0m '
        '--input=\u001b[33m".env"\u001b[0m '
        '--password=\u001b[33m"MyStrongPassword"\u001b[0m '
        '--model=\u001b[33m"lib/src/env_model.dart"\u001b[0m '
        '--null-safety');
  }
}
