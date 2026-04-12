local apps = import "lib/apps.libsonnet";
local window = import "lib/window.libsonnet";
local devices = import "lib/devices.libsonnet";
local complex = import "lib/complex_modifications.libsonnet";

{
  global: {
    enable_notification_window: false,
    show_in_menu_bar: false,
  },

  profiles: [
  {
      devices: [
      devices.naga,
      ],
      name: "Default profile",
      selected: true,
      virtual_hid_keyboard: {
         indicate_sticky_modifier_keys_state: false,
         keyboard_type_v2 : "ansi"
      },
      complex_modifications: {
        rules: [
            complex.zed,
            complex.simulator,
            complex.proxyman,
            complex.boosteroid,
            complex.safari,
            apps.rule,
            window.rule,

        ]
      }
   }
  ]
}
