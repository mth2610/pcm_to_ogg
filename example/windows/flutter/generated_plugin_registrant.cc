//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <pcm_to_ogg/pcm_to_ogg_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  PcmToOggPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PcmToOggPluginCApi"));
}
