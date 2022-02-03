
import 'package:api_to_model/headers.dart';

import 'input.dart';

class APIDetails {
  String? url;
  String? method;
  String? modelFilename;
  Headers? headers;
  Input? input;

  APIDetails(
      {this.url, this.method, this.modelFilename, this.input, this.headers});

  APIDetails.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    method = json['method'];
    modelFilename = json['model_filename'];
    headers =
        json['headers'] != null ? new Headers.fromJson(json['headers']) : null;
    input = json['input'] != null ? new Input.fromJson(json['input']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['method'] = this.method;
    data['model_filename'] = this.modelFilename;

    if (this.headers != null) {
      data['headers'] = this.headers?.toJson();
    }
    if (this.input != null) {
      data['input'] = this.input?.toJson();
    }
    return data;
  }
}
