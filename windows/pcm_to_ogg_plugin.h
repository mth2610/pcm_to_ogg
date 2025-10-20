#ifndef FLUTTER_PLUGIN_PCM_TO_OGG_PLUGIN_H_
#define FLUTTER_PLUGIN_PCM_TO_OGG_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace pcm_to_ogg {

class PcmToOggPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PcmToOggPlugin();

  virtual ~PcmToOggPlugin();

  // Disallow copy and assign.
  PcmToOggPlugin(const PcmToOggPlugin&) = delete;
  PcmToOggPlugin& operator=(const PcmToOggPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace pcm_to_ogg

#endif  // FLUTTER_PLUGIN_PCM_TO_OGG_PLUGIN_H_
