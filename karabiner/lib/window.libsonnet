local core = import "core.libsonnet";

local win(key, action) =
  core.basicManipulator(
    core.key(key, { mandatory: ["left_option", "left_shift", "left_control"] }),
    core.shell("~/.local/bin/win " + action)
  );

{
  rule: {
    description: "Movimento de janelas",
    manipulators: [
      win("h", "left"),
      win("l", "right"),
      win("j", "down"),
      win("k", "up"),
      win("f", "fullscreen"),
      win("c", "center"),
      win("equal_sign", "downRight"),
      win("b", "downLeft"),
      win("y", "upLeft"),
      win("p", "upRight"),
    ]
  }
}
