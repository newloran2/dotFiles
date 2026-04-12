local core = import "core.libsonnet";

local openApp(key, app) =
  core.basicManipulator(
    core.key(key, { mandatory: core.hyper }),
    core.shell('open -a "' + app + '"')
  );

local raw = {
  t: "Microsoft Teams",
  x: "Xcode",
  z: "Zed Preview",
  v: "Visual Studio Code",
  k: "Alacritty",
  e: "Sublime Text",
  b: "Safari",
  m: "Activity Monitor",
  i: "Mail",
  equal_sign: "Proxyman",
};


{
  rule: {
    description: "Abertura de apps",
    manipulators:
       [
        openApp(k, raw[k])
        for k in std.objectFields(raw)
      ]
  }
}
