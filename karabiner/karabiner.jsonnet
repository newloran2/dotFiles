local complex = import 'lib/complex_modifications.libsonnet';
local devices = import 'lib/devices.libsonnet';
{
  global: {
    enable_notification_window: false,
    show_in_menu_bar: false,
  },
  profiles: [
    {
      devices: [
        devices.naga,
        devices.naga_mouse,
        devices.naga_blue,
      ],
      name: 'Default profile',
      selected: true,
      virtual_hid_keyboard: {
        indicate_sticky_modifier_keys_state: false,
        keyboard_type_v2: 'ansi',
      },
      complex_modifications: {
        rules: [
            complex.apps, complex.simulator, complex.proxyman, complex.boosteroid,
            complex.zed, complex.safari, complex.win,
        ],
      },
    },
  ],
}
