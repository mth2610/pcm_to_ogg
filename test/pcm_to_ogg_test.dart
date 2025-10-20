import 'package:flutter_test/flutter_test.dart';
import 'package:pcm_to_ogg/pcm_to_ogg.dart';
import 'package:pcm_to_ogg/pcm_to_ogg_platform_interface.dart';
import 'package:pcm_to_ogg/pcm_to_ogg_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockPcmToOggPlatform
//     with MockPlatformInterfaceMixin
//     implements PcmToOggPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final PcmToOggPlatform initialPlatform = PcmToOggPlatform.instance;

//   test('$MethodChannelPcmToOgg is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelPcmToOgg>());
//   });

//   test('getPlatformVersion', () async {
//     PcmToOgg pcmToOggPlugin = PcmToOgg();
//     MockPcmToOggPlatform fakePlatform = MockPcmToOggPlatform();
//     PcmToOggPlatform.instance = fakePlatform;

//     // expect(await pcmToOggPlugin.getPlatformVersion(), '42');
//   });
// }
