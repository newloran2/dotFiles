local format_key(item, mods=null) =
  if std.type(item) == "object" then item
  else if std.type(item) == "array" then item
  else
    local is_button = std.type(item) == "string" && std.startsWith(item, "button");
    local base = if is_button then { pointing_button: item } else { key_code: item };
    if mods != null && mods != [] then base + { modifiers: mods } else base;

{
  // Exporta format_key explicitamente
  format_key: format_key,

  // Função map genérica (para manter compatibilidade com devices.libsonnet e outros)
  map(item, mods=null): format_key(item, mods),

  // Função para o Double Click
  mapDouble(from_item, to_double, double_mods, apps, to_single=null, single_mods=null):
    local var_name = "double_click_" + from_item;
    [
      {
        type: "basic",
        conditions: [
          { type: "frontmost_application_if", bundle_identifiers: apps },
          { type: "variable_if", name: var_name, value: 1 }
        ],
        from: format_key(from_item, { optional: ["any"] }),
        to: (
          if std.type(to_double) == "array" then to_double
          else [format_key(to_double, double_mods)]
        ) + [{ set_variable: { name: var_name, value: 0 } }],
      },
      {
        type: "basic",
        conditions: [{ type: "frontmost_application_if", bundle_identifiers: apps }],
        from: format_key(from_item, { optional: ["any"] }),
        to: [{ set_variable: { name: var_name, value: 1 } }],
        to_delayed_action: {
          to_if_invoked: [
            { set_variable: { name: var_name, value: 0 } },
          ] + (
            if to_single != null then
              if std.type(to_single) == "array" then to_single
              else [format_key(to_single, single_mods)]
            else []
          ),
          to_if_canceled: [{ set_variable: { name: var_name, value: 0 } }]
        },
        parameters: { "basic.to_delayed_action_delay_milliseconds": 250 }
      }
    ],
}
