import Flutter
import UIKit

public class PcmToOggPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "pcm_to_ogg", binaryMessenger: registrar.messenger())
    let instance = PcmToOggPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      // No-op on native, just for platform interface consistency
      result(nil)
    case "convert":
      guard let args = call.arguments as? [String: Any],
            let pcmDataTyped = args["pcmData"] as? FlutterStandardTypedData,
            let channels = args["channels"] as? Int,
            let sampleRate = args["sampleRate"] as? Int,
            let quality = args["quality"] as? Double else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid arguments for convert", details: nil))
          return
      }

      let pcmData = pcmDataTyped.data
      // A Float32 sample is 4 bytes
      let numSamples = pcmData.count / 4

      // Get a pointer to the PCM data bytes and call the C function
      let oggOutputPointer = pcmData.withUnsafeBytes { (pcmBytes: UnsafeRawBufferPointer) -> OpaquePointer? in
          // The C function expects a float pointer, so we bind the memory to Float
          let pcmFloatPtr = pcmBytes.baseAddress?.assumingMemoryBound(to: Float.self)

          // Call the C function, converting types as needed for C interop
          return encode_pcm_to_ogg(
              pcmFloatPtr,
              Int64(numSamples),
              Int32(channels),
              Int64(sampleRate),
              Float(quality)
          )
      }

      if let oggPtr = oggOutputPointer {
          // Ensure we have a valid pointer before proceeding
          guard let dataPtr = get_ogg_output_data(oggPtr) else {
              result(FlutterError(code: "CONVERSION_FAILED", message: "C function returned null data pointer", details: nil))
              // Still need to free the main struct to prevent leaks
              free_ogg_output(oggPtr)
              return
          }
          let dataSize = get_ogg_output_size(oggPtr)

          // Copy the data from the C pointer to a Swift Data object
          let oggData = Data(bytes: dataPtr, count: Int(dataSize))

          // IMPORTANT: Free the native memory allocated by the C function
          free_ogg_output(oggPtr)

          // Return the result to Dart
          result(FlutterStandardTypedData(data: oggData))
      } else {
          result(FlutterError(code: "CONVERSION_FAILED", message: "C function encode_pcm_to_ogg returned null", details: nil))
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
