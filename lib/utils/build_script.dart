import 'dart:io';

import 'package:api_to_model/utils/commands/clean.dart';
import 'package:api_to_model/utils/commands/generate_build_script.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:build_runner/src/build_script_generate/bootstrap.dart';
import 'package:build_runner/src/entrypoint/runner.dart';
import 'package:build_runner/src/logging/std_io_logging.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:logging/logging.dart';

class BuildScript {
  var localCommands = [CleanCommand(), GenerateBuildScript()];

  BuildCommandRunner? commandRunner;
  List<String>? args;
  ArgResults? parsedArgs;

  BuildScript(List<String> list,
      {this.args, this.commandRunner, this.parsedArgs});

  build() async {
    var localCommandNames = localCommands.map((c) => c.name).toSet();

    ArgResults? parsedArgs;
    try {
      if (args != null) {
        commandRunner =
            BuildCommandRunner([], await PackageGraph.forThisPackage());
        parsedArgs = commandRunner?.parse(args!);
      }
    } on UsageException catch (e) {
      print(red.wrap(e.message));
      print('');
      print(e.usage);
      exitCode = ExitCode.usage.code;
      return;
    }

    var commandName = parsedArgs?.command?.name;

    if (parsedArgs != null && parsedArgs.rest.isNotEmpty) {
      print(yellow
          .wrap('Could not find a command named "${parsedArgs.rest[0]}".'));
      print('');
      print(commandRunner?.usageWithoutDescription);
      exitCode = ExitCode.usage.code;
      return;
    }

    if (commandName == null || commandName == 'help') {
      commandRunner?.printUsage();
      return;
    }

    final logListener = Logger.root.onRecord.listen(stdIOLogListener());
    if (localCommandNames.contains(commandName) && parsedArgs != null) {
      var tempExitCode = await commandRunner?.runCommand(parsedArgs);
      exitCode = tempExitCode != null ? exitCode : -1;
    } else {
      if (args != null)
        while ((exitCode = await generateAndRun(args!)) ==
            ExitCode.tempFail.code) {}
    }
    await logListener?.cancel();
  }
}
