library api_to_model;

import 'package:api_to_model/src/json_to_model.dart';
import 'package:args/args.dart';

Future<void> main(List<String> arguments) async {
  var source;
  String? onlyFile;
  var output;
  var argParser = ArgParser();
  argParser
    ..addOption(
      'source',
      abbr: 's',
      // defaultsTo: './lib/jsons/',
      defaultsTo: './lib/api_list.json',
      callback: (v) => source = v,
      help: 'Specify source directory',
    )
    ..addOption(
      'output',
      abbr: 'o',
      defaultsTo: './lib/models/',
      callback: (v) => output = v,
      help: 'Specify models directory',
    )
    ..addOption(
      'onlyFile',
      abbr: 'f',
      defaultsTo: null,
      callback: (v) => onlyFile = v,
      help: 'Specify file to read',
    )
    ..parse(arguments);
  var runner =
      JsonModelRunner(source: source, output: output, onlyFile: onlyFile);
  runner..setup();

  print('Start generating');
  bool isRun = await runner.run();
  if (isRun) {
    // cleanup on success
    print('Cleanup');
    runner.cleanup();
  }
}
