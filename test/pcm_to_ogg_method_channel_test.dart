// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:pcm_to_ogg/pcm_to_ogg_method_channel.dart';

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   // MethodChannelPcmToOgg platform = MethodChannelPcmToOgg();
//   const MethodChannel channel = MethodChannel('pcm_to_ogg');

//   setUp(() {
//     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
//       channel,
//       (MethodCall methodCall) async {
//         return '42';
//       },
//     );
//   });

//   tearDown(() {
//     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
//   });

//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
