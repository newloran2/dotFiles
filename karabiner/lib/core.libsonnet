local core = import 'core.libsonnet';
local hyper = ["left_command", "left_option", "left_control", "left_shift"];
{
  hyper: hyper,

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
  }],

  win(key, action):
      self.basicManipulator(
         self.key(key, { mandatory: ["left_option", "left_shift", "left_control"] }),
         self.shell("~/.local/bin/win " + action)
      ),

   openApp(key, app):
      self.basicManipulator(
      self.key(key, { mandatory: hyper }),
      self.shell('open -a "' + app + '"')
      ),

   openApps(map):
   {
     rule: {
       description: 'Abertura de apps',
       manipulators:
         [
           core.openApp(k, map[k])
           for k in std.objectFields(map)
         ],
     },
   }
}
