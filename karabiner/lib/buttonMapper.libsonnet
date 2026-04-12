{
  map(item, mods=null):
    if std.type(item) == "object" then item
    else if std.type(item) == "array" then item
    else if std.startsWith(item, "button") then
    if mods != null then
       {pointing_button: item, modifiers:mods }
    else
      {pointing_button: item}
    else
    if mods != null then
       {key_code: item, modifiers: mods }
    else
      {key_code: item}
}
