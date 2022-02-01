import 'json_model.dart';

typedef JsonModelConverter = String Function(
    JsonModel? data, String? key, String? jsonKey, String? toJson,
    [bool isNested]);

class ModelTemplates {
  static JsonModelConverter fromJsonModel = (data, key, jsonKey, toJson,
          [isNested = false]) =>
      ModelTemplates.defaultTemplate(
          jsonModel: key,
          jsonKey: jsonKey,
          toJson: toJson,
          isNested: isNested,
          imports: data?.imports,
          fileName: data?.fileName,
          className: data?.className,
          declaration: data?.declaration,
          enums: data?.enums,
          enumConverters: data?.enumConverters,
          nestedClasses: data?.nestedClasses);

  static String defaultTemplate({
    String? jsonModel,
    String? jsonKey,
    String? toJson,
    bool? isNested,
    String? imports,
    String? fileName,
    String? className,
    String? declaration,
    String? enums,
    String? enumConverters,
    String? nestedClasses,
    String? keyListValue,
  }) {
    var template = '';
    var tempImports = imports != null ? imports.trim() : "";
    if (isNested != null && !isNested) {
      template += '''
$tempImports
''';
    }

    template += '''
class ${className ?? '/*TODO: className*/'} {
       
  ${declaration ?? '/*TODO: declaration*/'}
       
  ${className ?? '/*TODO: className*/'}({
    $jsonModel
  });

  ${className ?? '/*TODO: className*/'}.fromJson(Map<String,dynamic> json) {
    $jsonKey
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();  
    $toJson
    return data;
  }
  
''';

    if ((enumConverters?.length ?? 0) > 0) {
      template += '\n$enumConverters';
    }

    template += '}\n';

    if ((enums?.length ?? 0) > 0) {
      template += '\n$enums\n';
    }

    if ((nestedClasses?.length ?? 0) > 0) {
      template += '\n$nestedClasses';
    }

    return template;
  }

  static String indented(String content, {int? indent}) {
    indent = indent ?? 1;
    var indentString = (List.filled(indent, null, growable: false)
          ..fillRange(0, indent))
        .join('');

    content = content.replaceAll('\n', '\n$indentString');

    // return '$indentString$content';
    return '$content';
  }
}
