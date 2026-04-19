
local format_key(item, mods=null) =
  if std.type(item) == "object" then item
  else if std.type(item) == "array" then item
  else
    local is_button = std.type(item) == "string" && std.startsWith(item, "button");
    local base = if is_button then { pointing_button: item } else { key_code: item };
    if mods != null && mods != [] then base + { modifiers: mods } else base;

{
  format_key: format_key,

  // Função para cliques simples (usada pelo resto do sistema)
  map(item, mods=null): format_key(item, mods),

  // Função para Double Click
  mapDouble(from_item, to_double, double_mods, apps, to_single=null, single_mods=null):
    local var_name = "double_click_" + from_item;
    [
      {
        type: "basic",
        conditions: [
          { type: "frontmost_application_if", bundle_identifiers: apps },
          { type: "variable_if", name: var_name, value: 1 }
        ],
        from: format_key(from_item),
        to: (if std.type(to_double) == "array" then to_double else [format_key(to_double, double_mods)]) + [{ set_variable: { name: var_name, value: 0 } }],
      },
      {
        type: "basic",
        conditions: [{ type: "frontmost_application_if", bundle_identifiers: apps }],
        from: format_key(from_item),
        to: [{ set_variable: { name: var_name, value: 1 } }],
        to_delayed_action: {
          to_if_invoked: [{ set_variable: { name: var_name, value: 0 } }] + (if to_single != null then if std.type(to_single) == "array" then to_single else [format_key(to_single, single_mods)] else []),
          to_if_canceled: [{ set_variable: { name: var_name, value: 0 } }]
        },
        parameters: { "basic.to_delayed_action_delay_milliseconds": 200 }
      }
    ],

  // Função para Camadas (Segurar um botão e apertar outros)
  mapLayer(modifier, alone_action, triggers, apps):
    local var_name = "layer_" + modifier;
    local trigger_manipulators = [
      {
        type: "basic",
        conditions: [
          { type: "frontmost_application_if", bundle_identifiers: apps },
          { type: "variable_if", name: var_name, value: 1 }
        ],
        from: format_key(t.from),
        to: if std.type(t.to) == "array" then t.to else [format_key(t.to, t.mods)],
      }
      for t in triggers
    ];
    local activator = [
      {
        type: "basic",
        conditions: [{ type: "frontmost_application_if", bundle_identifiers: apps }],
        from: format_key(modifier),
        to: [{ set_variable: { name: var_name, value: 1 } }],
        to_after_key_up: [{ set_variable: { name: var_name, value: 0 } }],
        to_if_alone: if std.type(alone_action) == "array" then alone_action else [alone_action]
      }
    ];
    trigger_manipulators + activator,
}
