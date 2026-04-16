local mapper = import 'buttonMapper.libsonnet';

{
  map(apps, description, maps): {
    description: description,
    manipulators: std.flattenArrays([
      if std.objectHas(m, "double") && m.double then
        // Passamos os dados do single click se ele existir no objeto
        mapper.mapDouble(
            m.from,
            m.to,
            m.mods,
            apps,
            if std.objectHas(m, "single") then m.single.to else null,
            if std.objectHas(m, "single") then m.single.mods else null
        )
      else
        [{
          type: 'basic',
          conditions: [{ type: "frontmost_application_if", bundle_identifiers: apps }],
          from: mapper.format_key(m.from, { optional: ['any'] }),
          to: if std.type(m.to) == "array" then m.to else [mapper.format_key(m.to, m.mods)],
        }]
      for m in maps
    ]),
  },


  // chama de forma instantaea single click
  //{ from: 'button14', to: 'r', mods: ['left_command'] },
  // Botão 15: Com Double Click (Refresh) e Single Click (Close Tab)
   // {
   //   from: 'button15',
   //   double: true,
   //   to: 'r', mods: ['left_command'],
   //   single: { to: 'w', mods: ['left_command'] }
   // },

  zed: self.map(
    ['^io\\.zedapp\\.Zed$', '^dev\\.zed\\.Zed-Preview$'],
    'Zed Shortcuts',
    [
          {
            from: 'button5',
            double: true,
            to: 'f18', mods: ['left_command'],
            single: { to: 'f18', mods: [] }
          },
         //  { from: 'button5', to: 'f18', mods: [] },
         // { from: 'button5', to: 'f18', mods: ['left_command'] },
         { from: 'button6', to: [{ key_code: 'spacebar' }, { key_code: 'e' }, { key_code: 'e' }], mods: [] },
         { from: 'button7', to: 'b', mods: ['left_command'] },
         { from: 'button8', to: 'r', mods: ['left_command'] },
         { from: 'button9', to: 'escape', mods: ['left_shift'] },
         // {from:"button10", to: "r", mods: ["left_command"]},
         { from: 'button10', to: { shell_command: 'open -a "Proxyman"' }, mods: [] },
         { from: 'button11', to: { shell_command: "open -a 'Simulator'" }, mods: [] },
         { from: 'button13', to: 'o', mods: ['left_control'] },
         { from: 'button14', to: 'i', mods: ['left_control'] },
    ]
  ),

  simulator: self.map(
    ['^com\\.apple\\.iphonesimulator$'],
    'Simulator Shortcuts',
    [
      { from: 'button11', to: { shell_command: "open -a 'Zed Preview'" }, mods: [] },
      { from: 'button15', to: { shell_command: 'open -a Proxyman' }, mods: [] },
    ]
  ),

  proxyman: self.map(
    ['^com\\.proxyman\\.NSProxy$'],
    'Proxyman Shortcuts',
    [
      { from: 'button3', to: [
        { key_code: 'a', modifiers: ['left_command'] },
        { key_code: 'delete_or_backspace' },
      ], mods: [] },
      { from: 'button10', to: 'tab', mods: ['left_command'] },
      { from: 'button15', to: { shell_command: 'open -a Simulator' }, mods: [] },
    ]
  ),
  boosteroid: self.map(
    ['^com\\.boosteroid\\.macclient$'],
    'Boosteroid Shortcuts',
    [
      { from: 'button4', to: '1', mods: [] },
      { from: 'button5', to: '2', mods: [] },
      { from: 'button6', to: '3', mods: [] },
      { from: 'button7', to: '4', mods: [] },
      { from: 'button8', to: '5', mods: [] },
      { from: 'button9', to: '6', mods: [] },
      { from: 'button10', to: '7', mods: [] },
      { from: 'button11', to: '8', mods: [] },
      { from: 'button12', to: '9', mods: [] },
      { from: 'button13', to: '0', mods: [] },
      { from: 'button14', to: 'left_shift', mods: [] },
    ]
  ),
  safari: self.map(
    ['^com\\.apple\\.Safari$'],
    'Safari Shortcuts',
    [
      { from: 'button3', to: 'w', mods: ['left_command'] },
      { from: 'button5', to: 't', mods: ['left_command', 'left_shift'] },
      { from: 'button6', to: 'r', mods: ['left_command'] },
      { from: 'button7', to: 'r', mods: ['left_command', 'left_shift'] },
      { from: 'button10', to: 'tab', mods: ['left_control', 'left_shift'] },
      { from: 'button11', to: 'tab', mods: ['left_control'] },
      { from: 'button13', to: 'left_arrow', mods: ['left_command'] },
      { from: 'button14', to: 'right_arrow', mods: ['left_command'] },
      { from: 'button14', to: 'r', mods: ['left_command'], double: true},

    ]
  ),
}
