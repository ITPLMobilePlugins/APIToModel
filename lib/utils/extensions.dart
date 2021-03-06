

import 'package:api_to_model/core/dart_declaration.dart';
import 'package:api_to_model/core/json_model.dart';
import 'package:api_to_model/core/model_template.dart';

extension StringExtension on String {
  String toTitleCase() {
    var firstWord = toCamelCase();
    return '${firstWord.substring(0, 1).toUpperCase()}${firstWord.substring(1)}';
  }

  String toCamelCase() {
    var words = getWords();
    var leadingWords = words.getRange(1, words.length).toList();
    var leadingWord = leadingWords.map((e) => e.toTitleCase()).join('');
    return '${words[0].toLowerCase()}${leadingWord}';
  }

  String toSnakeCase() {
    var words = getWords();
    var leadingWord = words.map((e) => e.toLowerCase()).join('_');
    return '$leadingWord';
  }

  String? between(String start, String end) {
    final startIndex = indexOf(start);
    final endIndex = indexOf(end);
    if (startIndex == -1) return null;
    if (endIndex == -1) return null;
    if (endIndex <= startIndex) return null;

    return substring(startIndex + start.length, endIndex).trim();
  }

  List<String> getWords() {
    var trimmed = "";
    if (this != null) {
      trimmed = trim();
    } else {}
    List<String> value;

    value = trimmed.split(RegExp(r'[_\W]'));
    value = value.where((element) => element.isNotEmpty).toList();
    value = value
        .expand((e) => e.split(RegExp(r'(?=[A-Z])')))
        .where((element) => element.isNotEmpty)
        .toList();

    return value;
  }

  bool isTitleCase() {
    if (isEmpty) {
      return false;
    }
    if (trimLeft().isEmpty) {
      return false;
    }
    var firstLetter = trimLeft().substring(0, 1);
    if (double.tryParse(firstLetter) != null) {
      return false;
    }
    return firstLetter.toUpperCase() == substring(0, 1);
  }
}

extension JsonKeyModels on List<DartDeclaration> {
  String? toDeclarationStrings(String? className) {
    return map((e) => e.toDeclaration(className)).join('\n').trim();
  }

  String? toImportStrings() {
    List<String>? imports;
    where((element) => element.imports != null && element.imports.isNotEmpty)
        .map((e) => e.getImportStrings())
        .where((element) => element != null && element.isNotEmpty)
        .forEach((element) {
      imports?.addAll(element);
    });

    /* .fold<List<String?>>(
            <String>[], (prev, current) => prev..addAll(current));*/

    /*List<String>? nestedImports ;*/
    where((element) =>
            element.nestedClasses != null && element.nestedClasses!.isNotEmpty)
        .forEach((e1) {
      imports?.addAll(e1.imports);
    });
    /*.map((e) =>
            e.nestedClasses!.map((jsonModel) => jsonModel?.imports).toList())
        .fold<List<String?>>(
            <String>[], (prev, current) => prev..addAll(current));*/

    /*imports?.addAll(nestedImports);*/

    return imports?.join('\n');
  }

  String? getEnums(String? className) {
    return where((element) => element.isEnum)
        .map((e) => e.getEnum(className).toTemplateString())
        .where((element) => element != null && element.isNotEmpty)
        .join('\n');
  }

  String getNestedClasses() {
    return where((element) =>
            element.nestedClasses != null && element.nestedClasses!.isNotEmpty)
        .map((e) => e.nestedClasses?.map(
              (jsonModel) {
                var fromConstKeyMap =
                    JsonModel.fromConstKeyMap(jsonModel?.maps);
                var fromToJsonKeyMap =
                    JsonModel.fromToJsonKeyMap(jsonModel?.maps);
                var fromJsonKeyMap = JsonModel.fromJsonKeyMap(jsonModel?.maps);
                return ModelTemplates.fromJsonModel(jsonModel, fromConstKeyMap,
                    fromToJsonKeyMap, fromJsonKeyMap, true);
              },
            ).join('\n\n'))
        .join('\n');
  }

  List<String?>? getImportRaw() {
    List<String?>? importsRaw;
    where((element) => element.imports != null && element.imports.isNotEmpty)
        .forEach((element) {
      importsRaw?.addAll(element.imports);
      if (element.nestedClasses != null && element.nestedClasses!.isNotEmpty) {
        element.nestedClasses!.forEach((e) {
          e?.imports_raw?.forEach((e1) {
            importsRaw?.add(e1);
          });
        });
        /*importsRaw?.addAll(element.nestedClasses
            !.map((e) => e.imports_raw)
            .reduce((value, element) => value..addAll(element)));*/
      }
    });
    importsRaw = importsRaw
        ?.where((element) => element != null && element.isNotEmpty)
        .toList();
    return importsRaw;
  }
}
