import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Float32List;
import 'package:flutter/material.dart';
import 'package:pcm_to_ogg/pcm_to_ogg.dart';
import 'package:pcm_to_ogg/pcm_to_ogg_method_channel.dart';
import 'package:pcm_to_ogg/src/pcm_to_ogg_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Manually register the native implementation if not on the web.
  if (!kIsWeb) {
    PcmToOggPlatform.instance = MethodChannelPcmToOgg();
  }
  // The web implementation is registered automatically.
  // We will initialize it asynchronously in the app itself.

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Press the button to start.';
  Uint8List? _oggData;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPluginReady = false;
  bool _isInitializing = false;
  String _initError = '';

  @override
  void initState() {
    super.initState();
    _initializePlugin();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializePlugin() async {
    // On non-web platforms, initialization is instant.
    if (!kIsWeb) {
      setState(() {
        _isPluginReady = true;
        _status = 'Plugin ready on native platform.';
      });
      return;
    }

    // On web, it needs to download and compile the Wasm module.
    setState(() {
      _isInitializing = true;
      _status = 'Initializing WebAssembly module...';
    });

    try {
      await PcmToOgg.initialize();
      setState(() {
        _isPluginReady = true;
        _status = 'Plugin initialized. Click the button to convert.';
      });
    } catch (e) {
      setState(() {
        _initError = 'Failed to load plugin: $e';
        _status = _initError;
      });
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  // Hàm để tạo dữ liệu PCM giả (sóng sine 1 giây ở 440Hz)
  Float32List _generateDummyPcmData() {
    const sampleRate = 44100;
    const duration = 1; // 1 giây
    const frequency = 440.0; // Nốt A4
    const numSamples = sampleRate * duration;

    final random = Random();
    final list = Float32List(numSamples);
    for (var i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      // Tạo sóng sine và thêm một chút nhiễu
      list[i] =
          sin(2 * pi * frequency * t) * 0.5 +
          (random.nextDouble() - 0.5) * 0.01;
    }
    return list;
  }

  Future<void> _runConversion() async {
    if (!_isPluginReady) return;

    setState(() {
      _status = 'Generating PCM data...';
      _oggData = null;
    });

    // Tạo dữ liệu PCM 32-bit float, mono
    final pcmData = _generateDummyPcmData();

    setState(() {
      _status =
          'PCM data generated (${pcmData.lengthInBytes} bytes). Converting to OGG...';
    });

    try {
      await _audioPlayer.stop(); // Dừng phát lại nếu đang phát
      final stopwatch = Stopwatch()..start();
      final oggData = await PcmToOgg.convert(
        pcmData,
        channels: 1, // Mono
        sampleRate: 44100,
        quality: 0.6,
      );
      stopwatch.stop();

      setState(() {
        _status =
            'Conversion successful in ${stopwatch.elapsedMilliseconds}ms! OGG data size: ${oggData.lengthInBytes} bytes.';
        _oggData = oggData;
      });
    } catch (e) {
      setState(() {
        _status = 'An error occurred during conversion: $e';
      });
    }
  }

  Future<void> _playOggData() async {
    if (_oggData == null) return;

    try {
      await _audioPlayer.play(BytesSource(_oggData!));
      setState(() {
        _status = 'Playing audio...';
      });

      _audioPlayer.onPlayerComplete.first.then((_) {
        setState(() {
          _status = 'Playback complete.';
        });
      });
    } catch (e) {
      setState(() {
        _status = 'Error playing audio: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('PCM to OGG Plugin Example')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_initError.isNotEmpty)
                  Text(_initError, style: const TextStyle(color: Colors.red)),
                if (_isInitializing) const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(_status, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isPluginReady ? _runConversion : null,
                      child: const Text('Run Conversion'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isPluginReady && _oggData != null
                          ? _playOggData
                          : null,
                      child: const Text('Play Audio'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
