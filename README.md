# pcm_to_ogg

[![pub version](https://img.shields.io/pub/v/pcm_to_ogg.svg)](https://pub.dev/packages/pcm_to_ogg)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin to convert raw PCM audio data into the Ogg Vorbis format. It uses native C/C++ libraries (`libogg` and `libvorbis`) for high performance and supports all major platforms through Dart FFI and WebAssembly.

This plugin is ideal for applications that work with raw audio data, such as voice recorders, and need to encode it into a standardized, compressed format for storage or streaming.

## Features

- **High-Performance Encoding**: Utilizes the native `libogg` and `libvorbis` libraries for fast and efficient encoding.
- **Cross-Platform**: Works on Android, iOS, macOS, Windows, Linux, and Web.
- **Simple API**: A straightforward API with just two main methods: `initialize()` and `convert()`.
- **Web Support**: Uses a pre-compiled WebAssembly module for web compatibility.

## Supported Platforms

| Platform | Support |
| :--- | :--- |
| Android | ✅ |
| iOS | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |
| Web | ✅ |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pcm_to_ogg: ^1.0.0 # Replace with the latest version
```

Then, run `flutter pub get`.

## Web Platform Setup

To use this plugin on the Web, a manual one-time setup is required. You must copy the necessary WebAssembly files into your project's `web` directory.

1.  Locate the `pcm_to_ogg` package directory on your system (it is downloaded by Flutter into the pub cache).
2.  Find the pre-compiled web files inside the package at `lib/src/web/precompiled/`.
3.  Copy `pcm_to_ogg.js` and `pcm_to_ogg.wasm` from that directory.
4.  Paste them into the `web/` directory at the root of your Flutter application.

After copying the files, the plugin will be able to load and use them automatically.

## Basic Usage

Here is a simple example of how to use the plugin.

```dart
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pcm_to_ogg/pcm_to_ogg.dart';

// In a stateful widget...
Uint8List? oggData;

Future<void> runConversion(Float32List pcmData) async {
  try {
    // Initialize the plugin (especially needed for web)
    await PcmToOgg.initialize();

    // Perform the conversion
    final result = await PcmToOgg.convert(
      pcmData,
      channels: 1,
      sampleRate: 44100,
      quality: 0.7, // Quality from 0.0 to 1.0
    );

    setState(() {
      oggData = result;
    });

    print('Conversion successful! OGG size: ${result.lengthInBytes} bytes');

  } catch (e) {
    print('An error occurred: $e');
  }
}
```

### Important Notes

- Always call `PcmToOgg.initialize()` before the first conversion, especially on the web, as it needs to download and compile the WebAssembly module.
- The input PCM data must be a `Float32List`.