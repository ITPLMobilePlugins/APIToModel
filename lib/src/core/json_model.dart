import '../utils/extensions.dart';
import 'dart_declaration.dart';

class JsonModel {
  String? fileName;
  String? className;
  String? declaration;
  String? imports;
  List<String?>? imports_raw;
  String? enums;
  String? enumConverters;
  String? nestedClasses;
  Map<String, dynamic>? maps;

  JsonModel(String? fileName, List<DartDeclaration>? dartDeclarations,
      Map<String, dynamic>? value) {
    this.fileName = fileName;
    className = fileName?.toTitleCase();
    declaration = dartDeclarations?.toDeclarationStrings(className);
    imports = dartDeclarations?.toImportStrings();
    imports_raw = dartDeclarations?.getImportRaw();
    enums = dartDeclarations?.getEnums(className);
    nestedClasses = dartDeclarations?.getNestedClasses();
    maps = value;
  }

  // model string from json map
  static JsonModel fromMap(String? fileName, Map<String, dynamic>? jsonMap) {
    var dartDeclarations = <DartDeclaration>[];
    jsonMap?.forEach((key, value) {
      var declaration = DartDeclaration.fromKeyValue(key, value);
      return dartDeclarations.add(declaration);
    });

    // add key to template string
    // add value type to template string
    return JsonModel(fileName, dartDeclarations, jsonMap);
  }

  static String? fromConstKeyMap(Map<String, dynamic>? jsonMap) {
    String? keyValues;
    jsonMap?.forEach((key, value) {
      if (keyValues != null) {
        keyValues = "$keyValues\n    required this.$key,";
      } else {
        keyValues = "required this.$key,";
      }
    });
    return keyValues;
  }

  static String? fromToJsonKeyMap(Map<String, dynamic>? jsonMap) {
    String? keyValues;
    jsonMap?.forEach((key, value) {
      if (keyValues != null) {
        keyValues = "$keyValues\n    $key=json['${key.toString().toLowerCase()}'];";
      } else {
        keyValues = "$key=json['${key.toString().toLowerCase()}'];";
      }
    });
    return keyValues;
  }

  static String? fromJsonKeyMap(Map<String, dynamic>? jsonMap) {
    String? keyValues;
    jsonMap?.forEach((key, value) {
      if (keyValues != null) {
        keyValues =
            "$keyValues\n    data['$key']=${key.toString().toLowerCase()};";
      } else {
        keyValues = "data['$key']=${key.toString().toLowerCase()};";
      }
    });
    return keyValues;
  }
}
