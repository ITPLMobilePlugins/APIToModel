
import 'dart:convert';
import 'dart:io';

import 'package:api_to_model/utils/build_script.dart';
import 'package:api_to_model/utils/constants.dart';
import 'package:path/path.dart' as path;

import './core/json_model.dart';
import 'api_details.dart';
import 'core/model_template.dart';
import 'network/api_call.dart';

class JsonModelRunner {
  // String srcDir = './jsons/';
  String? srcDir = 'api_list.json';
  String? distDir = './lib/models/';
  String? onlyFile = './lib/models/';

  // List<FileSystemEntity> list = [];

  JsonModelRunner({String? source, String? output, String? onlyFile})
      : srcDir = source,
        distDir = output,
        onlyFile = onlyFile;

  void setup() {
    // if (srcDir.endsWith('/')) srcDir = srcDir.substring(0, srcDir.length - 1);
    if (distDir != null && distDir!.endsWith('/')) {
      distDir = distDir!.substring(0, distDir!.length - 1);
    }
  }

  Future<bool> run({command}) async {
    // run
    if (srcDir != null) {
      var apiList = loadAPIFile(srcDir!);
      if (apiList == null || apiList.isEmpty) return false;
      if (!generateModelsDirectory()) return false;
      if (isDuplicateNameAvailable(apiList)) return false;
      if (!await iterateJsonFile(apiList)) return false;
    }
    return true;
  }

  List<APIDetails>? loadAPIFile(String f) {
    var file = File(f);
    try {
      return (json.decode(file.readAsStringSync()) as List)
          .map((i) => APIDetails.fromJson(i))
          .toList();
    } catch (e) {
      print('error---> ' + e.toString());
      return null;
    }
  }

  void cleanup() async {
    // wrapup cleanup

    // build
    if (onlyFile == null) {
      await BuildScript(['build', '--delete-conflicting-outputs']).build();
    } else {
      if (srcDir != null) {
        var dotSplit = path.join(srcDir!, onlyFile).split('.');
        await BuildScript(['run', (dotSplit..removeLast()).join('.') + '.dart'])
            .build();
      }
    }
  }

  // all json files
  List<FileSystemEntity>? getAllJsonFiles() {
    if (srcDir != null) {
      var src = Directory(srcDir!);
      return src.listSync(recursive: true);
    }
    return null;
  }

  bool generateModelsDirectory() {
    if (distDir == null) return false;
    if (!Directory(distDir!).existsSync()) {
      Directory(distDir!).createSync(recursive: true);
    }
    return true;
  }

  // iterate json files
  Future<bool> iterateJsonFile(List<APIDetails> apiList) async {
    if (distDir == null) return false;
    var error = StringBuffer();
    var indexFile = '';
    for (int i = 0; i < apiList.length; i++) {
      var f = apiList[i];
      print("URL--> ${f.url}");
      var dartPath =
          f.modelFilename.toString().replaceAll('.dart', '').toLowerCase() +
              '.dart';

      var dartInputPath = f.modelFilename
              .toString()
              .replaceAll('.dart', '')
              .toLowerCase()
              .replaceAll("response", "") +
          '_request.dart';

      Map<String, dynamic>? jsonMap = await networkCall(f);

      var jsonModel =
          JsonModel.fromMap(f.modelFilename?.toLowerCase(), jsonMap);
      var fromConstKeyMap = JsonModel.fromConstKeyMap(jsonMap);
      var fromToJsonKeyMap = JsonModel.fromToJsonKeyMap(jsonMap);
      var fromJsonKeyMap = JsonModel.fromJsonKeyMap(jsonMap);

      if (!generateFileFromJson(distDir! + "/" + dartPath, jsonModel, dartPath,
          fromConstKeyMap, fromToJsonKeyMap, fromJsonKeyMap)) {
        error.write('cant write $dartPath');
      }

      if (f.input != null) {
        var name = f.modelFilename
            ?.toString()
            .toLowerCase()
            .replaceAll("response", "_request");
        var jsonInputModel = JsonModel.fromMap(name, f.input?.mInputValue);
        var fromInputConstKeyMap =
            JsonModel.fromConstKeyMap(f.input?.mInputValue);
        var fromInputToJsonKeyMap =
            JsonModel.fromToJsonKeyMap(f.input?.mInputValue);
        var fromInputJsonKeyMap =
            JsonModel.fromJsonKeyMap(f.input?.mInputValue);

        if (fromInputConstKeyMap != null &&
            fromInputToJsonKeyMap != null &&
            fromInputJsonKeyMap != null) {
          // warningIfImportNotExists(jsonModel, f);
          if (!generateFileFromJson(
              distDir! + "/" + dartInputPath,
              jsonInputModel,
              dartInputPath,
              fromInputConstKeyMap,
              fromInputToJsonKeyMap,
              fromInputJsonKeyMap)) {
            error.write('cant write $dartInputPath');
          }
        }
      }

      var relative = dartPath
          .replaceFirst(distDir! + path.separator, '')
          .replaceAll(path.separator, '/');
      print('generated: $relative');
      indexFile += "export '$relative';\n";

      if (i == apiList.length - 1) {
        File(path.join(distDir!, 'index.dart')).writeAsStringSync(indexFile);
        return indexFile.isNotEmpty;
      }
    }
    return false;
  }

  bool mapsEqual(Map m1, Map m2) {
    Iterable k1 = m1.keys;
    Iterable k2 = m2.keys;
    // Compare m1 to m2
    if (k1.length != k2.length) return false;
    for (dynamic o in k1) {
      if (!k2.contains(o)) return false;
      if (m1[o] is Map) {
        if (!(m2[o] is Map)) return false;
        if (!mapsEqual(m1[o], m2[o])) return false;
      } else {
        if (m1[o] != m2[o]) return false;
      }
    }
    return true;
  }

  Future<Map<String, dynamic>?> networkCall(APIDetails? apiDetails) async {
    try {
      if (apiDetails != null && apiDetails.url != null) {
        switch (apiDetails.method?.toUpperCase()) {
          case Constants.METHOD_GET:
            return await APICall().get(apiDetails.url!);
          case Constants.METHOD_POST:
            return await APICall().post(apiDetails.url!,
                data: apiDetails.input?.toJson(),
                header: apiDetails.headers?.toJson());
          case Constants.METHOD_PUT:
            return await APICall().put(apiDetails.url!,
                data: json.encode(apiDetails.input),
                header: apiDetails.headers?.toJson());
          case Constants.METHOD_DELETE:
            return await APICall().delete(apiDetails.url!);
        }
      }
    } catch (e) {
      print("---->${e.toString()}");
    }
    return null;
  }

  bool isDuplicateNameAvailable(List<APIDetails> apiList) {
    bool isduplicate = false;
    apiList.reduce((value, element) {
      if (value.modelFilename == element.modelFilename) {
        print("You have duplicate file name ${value.modelFilename}");
        isduplicate = true;
      }
      return element;
    });

    return isduplicate;
  }

  void warningIfImportNotExists(jsonModel, jsonFile) {
    jsonModel.imports_raw.forEach((importPath) {
      var parentPath =
          jsonFile.path.substring(0, jsonFile.path.lastIndexOf(path.separator));
      if (!File(path.join(parentPath, '$importPath.json')).existsSync()) {
        print(
            "[Warning] File '$importPath.json' not exist, import attempt on '${jsonFile.path}'");
      }
    });
  }

  // generate models from the json file
  bool generateFileFromJson(outputPath, JsonModel jsonModel, name,
      String? keyList, String? fromToJsonKeyMap, String? fromJsonKeyMap) {
    try {
      File(outputPath)
        ..createSync(recursive: true)
        ..writeAsStringSync(
          ModelTemplates.fromJsonModel(
              jsonModel, keyList, fromToJsonKeyMap, fromJsonKeyMap),
        );
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
