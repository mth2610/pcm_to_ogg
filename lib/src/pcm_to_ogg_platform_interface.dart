import 'dart:async';
import 'dart:typed_data';

abstract class PcmToOggPlatform {
  static PcmToOggPlatform? _instance;

  static PcmToOggPlatform get instance {
    if (_instance == null) {
      throw Exception(
        'PcmToOggPlatform not registered. Ensure the platform implementation is set.',
      );
    }
    return _instance!;
  }

  static set instance(PcmToOggPlatform impl) {
    _instance = impl;
  }

  Future<void> initialize();

  Future<Uint8List> convert(
    Float32List pcmData, {
    required int channels,
    required int sampleRate,
    double quality = 0.4,
  });
}
