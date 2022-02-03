import 'dart:convert';
import 'package:http/http.dart' as http;

class APICall {
  Future<Map<String, dynamic>> get(String url) async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Response: $jsonResponse.');
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return Map();
    }
  }

  Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic>? data, Map<String, dynamic>? header}) async {
    // Await the http get response, then decode the json-formatted response.
    http.Response response;
    data?.length;
    Map<String, String> headers = Map<String, String>();
    header?.forEach((k, v) => headers[k] = v);
    if (data!=null && data.isNotEmpty) {
      headers["content-length"] = json.encode(data).length.toString();
      print('headers--> ${headers.toString()}');
      response =
          await http.post(Uri.parse(url), body: json.encode(data), headers: headers);
    } else {
      response = await http.post(Uri.parse(url), headers: headers);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      print('Response: $jsonResponse.');
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return Map();
    }
  }

  Future<Map<String, dynamic>> put(String url,
      {String? data, Map<String, dynamic>? header}) async {
    // Await the http get response, then decode the json-formatted response.
    var response;
    Map<String, String> headers = Map<String, String>();
    header?.forEach((k, v) => headers[k] = v);

    if (data!=null && data.isNotEmpty) {
      headers["content-length"] = data.length.toString();

      response = await http.put(Uri.parse(url), body: data, headers: headers);
    } else {
      response = await http.put(Uri.parse(url));
    }
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Response: $jsonResponse.');
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return Map();
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('Response: $jsonResponse.');
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return Map();
    }
  }
}
