import 'dart:async';
import 'dart:typed_data';

import '../../pcm_to_ogg_platform_interface.dart';

class PcmToOggWeb extends PcmToOggPlatform {
  static Future<PcmToOggWeb> create() async {
    throw UnimplementedError('Web platform not supported on this build.');
  }

  @override
  Future<void> initialize() {
    throw UnimplementedError('Web platform not supported on this build.');
  }

  @override
  Future<Uint8List> convert(
    Float32List pcmData, {
    required int channels,
    required int sampleRate,
    double quality = 0.4,
  }) {
    throw UnimplementedError('Web platform not supported on this build.');
  }
}

class PcmToOggNative extends PcmToOggPlatform {
  PcmToOggNative() {
    throw UnimplementedError('Native platform not supported on this build.');
  }

  @override
  Future<void> initialize() {
    throw UnimplementedError('Native platform not supported on this build.');
  }

  @override
  Future<Uint8List> convert(
    Float32List pcmData, {
    required int channels,
    required int sampleRate,
    double quality = 0.4,
  }) {
    throw UnimplementedError('Native platform not supported on this build.');
  }
}
