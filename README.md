<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

# Json to Model Generator

Json to Model generator is a Command line tool for generating Dart models (json_serializable) using API calls. Given an API details, this library will generate all the necessary Dart classes to parse and generate JSON.

## Installation

on `pubspec.yaml`

```yaml
path: 1.8.0
  args: 2.3.0
  build_runner_core: 7.1.0
  io: 1.0.3
  logging: 1.0.0
  expressions: 0.2.3
  build_runner: 2.1.0
  json_serializable: 6.1.4
  json_annotation: 4.4.0
  http:
  dynamic_model_gen:
    path: path/to/dynamic_model_gen
```

install using `pub get` command or if you using dart vscode/android studio, you can use install option.

## Why

### Problem

You might have a system or back-end REST app, and you want to build a dart app. you may start create models for your data. but to convert from Dart `Map` need extra work, so you can use `json_serializable`, but it just to let you handle data conversion, you still need to type it model by model, what if you have huge system that require huge amount of models. to write it all up might distress you.

### Solution

This command line tool will read your existing `api_list.json` file from your project lib folder and hit the API. If it is success, response will convert into dart(json_serializable) files.

***Note  :    Don't rename the _api_list.json_ file. And paste it into your /lib folder.***

### How

Command line tool read your `api_list.json` file and hit the api url, get the response and  find the possible type, variable name, import uri, decorator and will write it into the templates.

Create/copy `api_list.json` files into `/lib`(default) on root of your project. Add your API details in `api_list.json` file.

`url` is your API url.

`method` is your API method - `GET, POST, PUT, DELETE`

`model_filename` is name of your model file name.

`headers` are API headers.

`input` is request body data.

Create `.dart` file inside `/bin` folder and  add the following line.

```dart
export 'package:api_to_model/api_to_model.dart';
```

and then run the following command

```dart
flutter pub run filename.dart
```

_filename.dart_ is the name of the file which you have created insdie the `/bin` folder.

Now, the tool will read your API list which you have added in `api_list.json` file and create the model files inside `/lib/models/`
