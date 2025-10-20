import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';
import 'dart:typed_data';

import '../pcm_to_ogg_platform_interface.dart';

// --- C-side Struct Definition ---
final class _OggOutput extends Struct {
  external Pointer<Uint8> data;
  @Int32()
  external int size;
}

// --- FFI Function Signatures ---
typedef _EncodePcmToOggNative =
    Pointer<_OggOutput> Function(
      Pointer<Float> pcmData,
      Int64 numSamples,
      Int32 channels,
      Int64 sampleRate,
      Float quality,
    );
typedef _EncodePcmToOggDart =
    Pointer<_OggOutput> Function(
      Pointer<Float> pcmData,
      int numSamples,
      int channels,
      int sampleRate,
      double quality,
    );

typedef _FreeOggOutputNative = Void Function(Pointer<_OggOutput>);
typedef _FreeOggOutputDart = void Function(Pointer<_OggOutput>);

/// The native implementation of the PcmToOggPlatform.
class PcmToOggNative extends PcmToOggPlatform {
  static late final _EncodePcmToOggDart _encodePcmToOgg;
  static late final _FreeOggOutputDart _freeOggOutput;
  bool _isInitialized = false;

  /// Registers the native implementation with the platform interface.
  static void registerWith() {
    PcmToOggPlatform.instance = PcmToOggNative();
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    final dylib = _loadNativeLibrary();

    _encodePcmToOgg = dylib
        .lookup<NativeFunction<_EncodePcmToOggNative>>('encode_pcm_to_ogg')
        .asFunction();

    _freeOggOutput = dylib
        .lookup<NativeFunction<_FreeOggOutputNative>>('free_ogg_output')
        .asFunction();

    _isInitialized = true;
  }

  static DynamicLibrary _loadNativeLibrary() {
    if (Platform.isMacOS || Platform.isIOS) {
      return DynamicLibrary.open('pcm_to_ogg.framework/pcm_to_ogg');
    }
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('libpcm_to_ogg.so');
    }
    if (Platform.isWindows) {
      return DynamicLibrary.open('pcm_to_ogg_plugin.dll');
    }
    throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
  }

  @override
  Future<Uint8List> convert(
    Float32List pcmData, {
    required int channels,
    required int sampleRate,
    double quality = 0.4,
  }) async {
    if (!_isInitialized) {
      throw Exception(
        'PcmToOgg.initialize() must be called before using convert().',
      );
    }

    final pcmPointer = calloc<Float>(pcmData.length);
    pcmPointer.asTypedList(pcmData.length).setAll(0, pcmData);

    try {
      final resultPointer = _encodePcmToOgg(
        pcmPointer,
        pcmData.length,
        channels,
        sampleRate,
        quality,
      );

      if (resultPointer == nullptr) {
        throw Exception(
          'Failed to encode PCM data. The native function returned a null pointer.',
        );
      }

      try {
        final int size = resultPointer.ref.size;
        final Pointer<Uint8> dataPointer = resultPointer.ref.data;

        if (dataPointer == nullptr) {
          throw Exception(
            'Native function returned a null data pointer inside the result struct.',
          );
        }

        final oggData = Uint8List.fromList(dataPointer.asTypedList(size));
        return oggData;
      } finally {
        _freeOggOutput(resultPointer);
      }
    } finally {
      calloc.free(pcmPointer);
    }
  }
}
