import 'dart:async';
import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../pcm_to_ogg_platform_interface.dart';

// Extension for the result of WebAssembly.instantiate
extension type WasmInstantiateResult._(JSObject _) implements JSObject {
  external JSObject get instance;
}

// Extension for WebAssembly.Instance
extension type WasmInstance._(JSObject _) implements JSObject {
  external _WasmExports get exports;
}

// Extension for the Wasm module's exports
extension type _WasmExports._(JSObject _) implements JSObject {
  external JSUint8Array get HEAPU8;
  external JSFloat32Array get HEAPF32;
  external JSUint32Array get HEAPU32;
  @JS('_malloc')
  external JSNumber malloc(JSNumber size);
  @JS('_free')
  external void free(JSNumber ptr);
  @JS('_encode_pcm_to_ogg')
  external JSNumber encode_pcm_to_ogg(
    JSNumber pcmPtr,
    JSNumber numSamples,
    JSNumber channels,
    JSNumber sampleRate,
    JSNumber quality,
  );
  @JS('_get_ogg_output_data')
  external JSNumber get_ogg_output_data(JSNumber ptr);
  @JS('_get_ogg_output_size')
  external JSNumber get_ogg_output_size(JSNumber ptr);
  @JS('_free_ogg_output')
  external void free_ogg_output(JSNumber ptr);
}

// Extensions to add missing members
extension JSUint8ArrayExt on JSUint8Array {
  external JSArrayBuffer get buffer;
  external JSUint8Array slice(int begin, [int? end]);
}

extension JSFloat32ArrayExt on JSFloat32Array {
  external void set(JSAny array, int offset);
}

extension JSUint32ArrayExt on JSUint32Array {
  external JSNumber operator [](int index);
}

/// The web implementation of the PcmToOggPlatform.
class PcmToOggWeb extends PcmToOggPlatform {
  _WasmExports? _wasmExports;
  bool _isInitialized = false;

  static void registerWith(Registrar registrar) {
    PcmToOggPlatform.instance = PcmToOggWeb();
  }

  PcmToOggWeb();

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. If the factory doesn't exist, inject the script and wait for it.
    if (!globalContext.hasProperty('PcmToOggModuleFactory'.toJS).toDart) {
      final script = html.ScriptElement()
        ..type = 'module'
        ..innerHtml = '''
          import createPcmToOggModule from '/pcm_to_ogg.js';
          window.PcmToOggModuleFactory = createPcmToOggModule;
        ''';
      html.document.head!.append(script);

      // 2. Poll to check when the factory is available.
      const maxRetries = 200; // Wait up to 10 seconds
      var retries = 0;
      while (!globalContext.hasProperty('PcmToOggModuleFactory'.toJS).toDart) {
        if (retries++ > maxRetries) {
          throw Exception('PcmToOggWeb: Timed out waiting for PcmToOggModuleFactory.');
        }
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    // Now, PcmToOggModuleFactory should be globally available.
    final createModule = globalContext['PcmToOggModuleFactory'] as JSFunction;
    final modulePromise = createModule.callAsFunction(globalContext) as JSPromise;
    final module = (await modulePromise.toDart) as JSObject;

    _wasmExports = _WasmExports._(module);

    _isInitialized = true;
  }

  @override
  Future<Uint8List> convert(
    Float32List pcmData, {
    required int channels,
    required int sampleRate,
    double quality = 0.4,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    if (_wasmExports == null) {
      throw Exception('Wasm module not initialized.');
    }

    final pcmDataSize = pcmData.length * pcmData.elementSizeInBytes;
    final pcmPtr = _wasmExports!.malloc(pcmDataSize.toJS).toDartInt;
    if (pcmPtr == 0) {
      throw Exception('Wasm _malloc failed to allocate memory for PCM data.');
    }

    try {
      _wasmExports!.HEAPF32.set(pcmData.toJS, pcmPtr >> 2);

      final resultPtr = _wasmExports!
          .encode_pcm_to_ogg(
            pcmPtr.toJS,
            pcmData.length.toJS,
            channels.toJS,
            sampleRate.toJS,
            quality.toJS,
          )
          .toDartInt;

      if (resultPtr == 0) {
        throw Exception(
          'Wasm function \'encode_pcm_to_ogg\' returned a null pointer.',
        );
      }

      try {
        final dataPtr = _wasmExports!
            .get_ogg_output_data(resultPtr.toJS)
            .toDartInt;
        final size = _wasmExports!
            .get_ogg_output_size(resultPtr.toJS)
            .toDartInt;

        if (dataPtr == 0) {
          throw Exception(
            'Wasm function returned a null data pointer inside the result struct.',
          );
        }

        final oggData = _wasmExports!.HEAPU8
            .slice(dataPtr, dataPtr + size)
            .toDart;
        return oggData;
      } finally {
        _wasmExports!.free_ogg_output(resultPtr.toJS);
      }
    } finally {
      _wasmExports!.free(pcmPtr.toJS);
    }
  }
}
