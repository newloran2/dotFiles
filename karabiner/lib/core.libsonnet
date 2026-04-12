{
  hyper: ["left_command", "left_option", "left_control", "left_shift"],

  basicManipulator(from, to, extra={}): {
    type: "basic",
    from: from,
    to: to,
  } + extra,

  key(key, mods): {
    key_code: key,
    modifiers: mods,
  },

  shell(cmd): [{ shell_command: cmd }],

  keyPress(key, mods=[]): [{
    key_code: key,
    modifiers: mods,
  }]
}
