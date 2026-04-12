local core = import "core.libsonnet";
local cond = import "conditions.libsonnet";
local mapper = import "buttonMapper.libsonnet";

{
   map(apps, description, maps): {
      description: description,
      manipulators: [
         cond.frontmost(apps) + {
            type: "basic",
            from: mapper.map(m.from, {optional: ["any"]}) ,
            to: mapper.map(m.to,m.mods)
         }
         for m in maps
      ],
   },


   zed: self.map(
      ["^io\\.zedapp\\.Zed$", "^dev\\.zed\\.Zed-Preview$"],
      "Zed Shortcuts",
      [
         {from:"button4", to: "f18", mods: []},
         {from:"button5", to: "f18", mods: ["left_command"]},
         {from:"button6", to: [{"key_code": "spacebar"},{"key_code": "e"}, {"key_code": "e"}], mods: []},
         {from:"button7", to: "b", mods: ["left_command"]},
         {from:"button8", to: "r", mods: ["left_command"]},
         {from:"button9", to: "escape", mods: ["left_shift"]},
         // {from:"button10", to: "r", mods: ["left_command"]},
         {from:"button10", to: {"shell_command": "open -a \"Proxyman\""}, mods: []},
         {from:"button11", to: {"shell_command": "open -a 'Simulator'"}, mods: []},
         {from:"button13", to: "o", mods: ["left_control"]},
         {from:"button14", to: "i", mods: ["left_control"]},
      ]
   ),

   simulator: self.map(
      ["^com\\.apple\\.iphonesimulator$"],
      "Simulator Shortcuts",
      [
         {from:"button11", to: {"shell_command": "open -a 'Zed Preview'"}, mods: []},
      ]
   ),

   proxyman: self.map(
      ["^com\\.proxyman\\.NSProxy$"],
      "Proxyman Shortcuts",
      [
         {from:"button10", to: "tab", mods: ["left_command"]},
      ]
   ),
   boosteroid: self.map(
      ["^com\\.boosteroid\\.macclient$"],
      "Boosteroid Shortcuts",
      [
         {from:"button4", to: "1", mods: []},
         {from:"button5", to: "2", mods: []},
         {from:"button6", to: "3", mods: []},
         {from:"button7", to: "4", mods: []},
         {from:"button8", to: "5", mods: []},
         {from:"button9", to: "6", mods: []},
         {from:"button10", to: "7", mods: []},
         {from:"button11", to: "8", mods: []},
         {from:"button12", to: "9", mods: []},
         {from:"button13", to: "0", mods: []},
         {from:"button14", to: "left_shift", mods: []},
      ]
   ),
   safari: self.map(
      ["^com\\.apple\\.Safari$"],
      "Safari Shortcuts",
      [
         {from:"button3", to: "w", mods: ["left_command"]},
         {from:"button5", to: "t", mods: ["left_command", "left_shift"]},
         {from:"button6", to: "r", mods: ["left_command"]},
         {from:"button10", to: "tab", mods: ["left_control", "left_shift"]},
         {from:"button11", to: "tab", mods: ["left_control"]},
         {from:"button13", to: "left_arrow", mods: ["left_command"]},
         {from:"button14", to: "right_arrow", mods: ["left_command"]},

      ]
   ),
}
