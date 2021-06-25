//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <mm2_native/mm2_native_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) mm2_native_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "Mm2NativePlugin");
  mm2_native_plugin_register_with_registrar(mm2_native_registrar);
}
