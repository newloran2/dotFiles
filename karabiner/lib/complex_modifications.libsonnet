local mapper = import 'buttonMapper.libsonnet';
local core = import 'core.libsonnet';

{
map(apps, description, maps): {
  description: description,
  manipulators: std.flattenArrays([
    // Caso 1: Layer (Segurar botão modificador)
    if std.objectHas(m, "layer") then
      mapper.mapLayer(
        m.layer,
        mapper.format_key(m.to, m.mods),
        m.triggers,
        apps
      )

    // Caso 2: Double Click
    else if std.objectHas(m, "double") && m.double then
      mapper.mapDouble(
        m.from,
        m.to,
        m.mods,
        apps,
        if std.objectHas(m, "single") then m.single.to else null,
        if std.objectHas(m, "single") then m.single.mods else null
      )

    // Caso 3: Clique Simples
    else
    [{
        type: 'basic',
        from: mapper.format_key(m.from),
        to: if std.type(m.to) == "array" then m.to else [mapper.format_key(m.to, m.mods)],
      } + (
        // Só adiciona o campo conditions se apps não for null e tiver itens
        if apps != null && std.type(apps) == 'array' && std.length(apps) > 0 then
          { conditions: [{ type: "frontmost_application_if", bundle_identifiers: apps }] }
        else {}
      )]
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
   // layer onde segura um botão to e aperta o from
   // caso o layer seja precionado pressionado e solto apenas o evento de to é disparado
   // caso seja segurado e apertado o um dos from do triggers o to do triger em questão é disparado
   // TODO: controlar adequadamente quando o layer for usado juntamente com o double
   // {
   //    layer: 'button14',
   //    to: "i", mods: ['left_control'],
   //    triggers: [
   //       { from: 'button1', to: [{key_code: "escape"},{key_code: "left_shift"},{key_code: "backslash"},], mods: [] },
   //       { from: 'button2', to: [{key_code: "escape"},{key_code: "left_shift"},{key_code: "hyphen"},], mods: [] },
   //       { from: 'button3', to: 'w', mods: ['left_command'] },
   //    ]
   // },
  zed: self.map(
    ['^io\\.zedapp\\.Zed$', '^dev\\.zed\\.Zed-Preview$'],
    'Zed Shortcuts',
    [

          {
             layer: 'button6',
             to: [{ key_code: 'spacebar' }, { key_code: 'e' }, { key_code: 'e' }], mods: [],
             triggers: [
                { from: 'button1', to: 'f18', mods: [] },
                { from: 'button2', to: 'f18', mods: ['left_command'] },
             ]
          },
         {
            layer: 'button13',
            to: 'o', mods: ['left_control'],
            triggers: [
               { from: 'button2', to: 'r', mods: ['left_command'] },
               { from: 'button1', to: 'b', mods: ['left_command'] },
               // { from: 'button3', to: 'w', mods: ['left_command'] },
            ]
         },
         {
            layer: 'button14',
            to: "i", mods: ['left_control'],
            triggers: [
               { from: 'button1', to: [{pointing_button:"button1"},{key_code: "escape"},{key_code: "left_shift"},{key_code: "backslash"}], mods: [] },
               { from: 'button2', to: [{pointing_button:"button1"},{key_code: "escape"},{key_code: "left_shift"},{key_code: "hyphen"}], mods: [] },
               { from: 'button3', to: 'w', mods: ['left_command'] },
            ]
         },
         {
            layer: 'button15',
            to: "tab", mods: ['left_command'],
            triggers: [
               { from: 'button1', to: { shell_command: 'open -a "Proxyman"' }, mods: [] },
               { from: 'button2', to: { shell_command: 'open -a "Simulator"' }, mods: [] },
               { from: 'button3', to: { shell_command: 'open -a "Safari"' }, mods: [] },
            ]
         }

    ]
  ),

  simulator: self.map(
    ['^com\\.apple\\.iphonesimulator$'],
    'Simulator Shortcuts',
    [
      {
         layer: 'button15',
         to: 'tab', mods: ['left_command'],
         triggers: [
            { from: 'button1', to: { shell_command: 'open -a "Proxyman"' }, mods: [] },
            { from: 'button2', to: { shell_command: 'open -a "Zed Preview"' }, mods: [] },
            { from: 'button3', to: { shell_command: 'open -a "Safari"' }, mods: [] },
         ]
      }
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
      {
         layer: 'button15',
         to: 'tab', mods: ['left_command'],
         triggers: [
            { from: 'button1', to: { shell_command: 'open -a "Smua"' }, mods: [] },
            { from: 'button2', to: { shell_command: 'open -a "Zed Preview"' }, mods: [] },
            { from: 'button3', to: { shell_command: 'open -a "Safari"' }, mods: [] },
         ]
      }
      { from: 'button15', to: 'tab', mods: ['left_command']},
      // { from: 'button15', to: { shell_command: 'open -a Simulator' }, mods: [] },
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
      { from: 'button15', to: 'tab', mods: ['left_command']},
    ]
  ),

  win: {
    rule: {
      description: "Movimento de janelas",
      manipulators: [
        core.win("h", "left"),
        core.win("l", "right"),
        core.win("j", "down"),
        core.win("k", "up"),
        core.win("f", "fullscreen"),
        core.win("c", "center"),
        core.win("period", "downRight"),
        core.win("b", "downLeft"),
        core.win("y", "upLeft"),
        core.win("p", "upRight"),
      ]
    }
  },
  apps: core.openApps({
     f: 'Finder',
     t: 'Teams',
     x: 'Xcode',
     z: 'Zed Preview',
     v: 'Visual Studio Code',
     k: 'Alacritty',
     e: 'Sublime Text',
     b: 'Safari',
     m: 'Activity Monitor',
     i: 'Mail',
     equal_sign: 'Proxyman'
  })
}
