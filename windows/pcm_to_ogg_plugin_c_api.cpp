#include "include/pcm_to_ogg/pcm_to_ogg_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "pcm_to_ogg_plugin.h"

void PcmToOggPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  pcm_to_ogg::PcmToOggPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
