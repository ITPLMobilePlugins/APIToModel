import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:api_to_model/api_to_model.dart';

void main() {
  const MethodChannel channel = MethodChannel('api_to_model');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await ApiToModel.platformVersion, '42');
  });
}
