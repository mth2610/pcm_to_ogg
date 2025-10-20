import 'dart:async';
import 'dart:typed_data';

import 'src/pcm_to_ogg_platform_interface.dart';

class PcmToOgg {
  static PcmToOggPlatform?
  platform; // Add this to match your registration code's setter usage

  // static set platform(PcmToOggPlatform? value) {
  //   PcmToOggPlatform.instance = value!;
  // }

  static Future<void> initialize() async {
    await PcmToOggPlatform.instance.initialize();
  }

  static Future<Uint8List> convert(
    Float32List pcmData, {
    required int channels,
    required int sampleRate,
    double quality = 0.4,
  }) async {
    return PcmToOggPlatform.instance.convert(
      pcmData,
      channels: channels,
      sampleRate: sampleRate,
      quality: quality,
    );
  }
}
