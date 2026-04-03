local windowHyper = { 'shift', 'alt', 'ctrl' }
local appHyper = { 'cmd', 'alt', 'ctrl', 'shift' }
local mouseHyper = { 'cmd', 'alt', 'ctrl', 'shift' }
local moveHyper = { 'alt', 'cmd' }

hs.mouse.setAbsolutePosition = true
hs.window.animationDuration = 0.1

-- Estilo customizado para alertas
hs.alert.defaultStyle = {
   strokeColor = { alpha = 0 },
   strokeWidth = 2,
   fillColor = { red = 0.1, green = 0.1, blue = 0.1, alpha = 0.85 },
   radius = 12,
   textColor = { red = 1, green = 1, blue = 1 },
   textFont = "Menlo",
   textSize = 22,
   padding = 18,
   atScreenEdge = 0,
   fadeInDuration = 0.15,
   fadeOutDuration = 0.25,
}

hs.grid.ui.showExtraKeys = false
hs.grid.setGrid('10x4')
hs.grid.ui.textSize = 30

local function lastApp()
   return function()
      if lastOpenedApp ~= nil then
         hs.application.launchOrFocus(lastOpenedApp)
      end
   end
end

local function nextSpace()
   return function()
      local space = hs.spaces.activeSpaceOnScreen()
      hs.printf("Espaço atual: %d", space)
      hs.spaces.gotoSpace(space + 1)
   end
end

local function previousSpace()
   return function()
      hs.spaces.gotoSpace(hs.spaces.activeSpaceOnScreen() - 1)
   end
end



local function positionWindow(x, y, w, h)
   -- o posiocionamento funciona da seguinte forma
   -- o gid configurado sendo 9x4
   -- x pode ser de 0 a 9 se passar do tamanho maximo considera o tamanho maximo
   -- y a mesma logica do x
   -- h e w são a altura e a largura e se aplicam na mesma logica de x
   return function()
      local win = hs.window.focusedWindow()
      hs.grid.set(win, hs.geometry.rect(x, y, w, h))
   end
end

local function resizeWindow(direction)
   return function()
      local win = hs.window.focusedWindow()
      if direction == "up" then
         hs.grid.resizeWindowShorter(win)
      elseif direction == "down" then
         hs.grid.resizeWindowTaller(win)
      elseif direction == "left" then
         hs.grid.resizeWindowThinner(win)
      elseif direction == "right" then
         hs.grid.resizeWindowWider(win)
      end
   end
end

local function moveWindow(direction)
   return function()
      local win = hs.window.focusedWindow()
      if direction == "up" then
         hs.grid.pushWindowUp(win)
      elseif direction == "down" then
         hs.grid.pushWindowDown(win)
      elseif direction == "left" then
         hs.grid.pushWindowLeft(win)
      elseif direction == "right" then
         hs.grid.pushWindowRight(win)
      end
   end
end

-- x, y, w, h devem ser valores entre 0 e 1 (porcentagem da tela)
local function moveAndResizeWindow(x, y, w, h)
   return function()
      local win = hs.window.focusedWindow()
      if win then
         local screen = win:screen()
         local frame = screen:frame()
         win:setFrame({
            x = frame.x + frame.w * x,
            y = frame.y + frame.h * y,
            w = frame.w * w,
            h = frame.h * h
         })
      end
   end
end

local function nextMonitor()
   return function()
      local app = hs.window.focusedWindow()
      app:moveToScreen(app:screen():next())
      -- app:maximize()
   end
end

-- Função para executar um comando de linha de comando
local function runCommand(command, callback)
   hs.task.new("/bin/bash", function()
      if callback then
         callback()
      end
   end, function(task, stdout, stderr)
   end, { "-c", command }):start()
end

local function scroll(position, mods)
   local scrollEvent = hs.eventtap.event.newScrollEvent({ -1, 0 }, {}, "pixel")
   scrollEvent:post()
end

local function launchAppOrFocus(app)
   return function()
      hs.application.launchOrFocus(app)
   end
end
local function emacsclient()
   hs.alert.show("Abrindo Emacs...")
   hs.execute("~/.hammerspoon/emacsclientOrEmacs.sh")
end

local function left() positionWindow({ x = 0, y = 0, w = 5, h = 4 })() end
local function right() positionWindow({ x = 5, y = 0, w = 5, h = 4 })() end
local function up() positionWindow({ x = 0, y = 0, w = 10, h = 2 })() end
local function down() positionWindow({ x = 0, y = 2, w = 10, h = 2 })() end
local function topLeft() positionWindow({ x = 0, y = 0, w = 5, h = 2 })() end
local function topRight() positionWindow({ x = 5, y = 0, w = 5, h = 2 })() end
local function bottomLeft() positionWindow({ x = 0, y = 2, w = 5, h = 2 })() end
local function bottomRight() positionWindow({ x = 5, y = 2, w = 5, h = 2 })() end
local function center() positionWindow({ x = 2, y = 0, w = 5, h = 4 })() end
local function maximize() positionWindow({ x = 0, y = 0, w = 10, h = 10 })() end


local shortcuts = hs.loadSpoon("EShortcuts")
shortcuts:bind {
   ["*"] = {
      { mods = { "cmd" },   key = "f13",  fn = hs.spaces.toggleMissionControl },

      { mods = windowHyper, key = "f",    fn = maximize },
      { mods = windowHyper, key = "h",    fn = left },
      { mods = windowHyper, key = "l",    fn = right },
      { mods = { "cmd" },   key = "pad0", fn = left },
      { mods = { "shift" }, key = "pad2", fn = right },
      { mods = windowHyper, key = "k",    fn = up },
      { mods = windowHyper, key = "j",    fn = down },
      { mods = windowHyper, key = "y",    fn = topLeft },
      { mods = windowHyper, key = "p",    fn = topRight },
      { mods = windowHyper, key = "b",    fn = bottomLeft },
      { mods = windowHyper, key = ".",    fn = bottomRight },
      { mods = windowHyper, key = "c",    fn = center },

      { mods = appHyper,    key = "p",    fn = emacsclient },
      { mods = appHyper,    key = "t",    fn = launchAppOrFocus("Teams") },
      { mods = appHyper,    key = "x",    fn = launchAppOrFocus("Xcode") },
      { mods = appHyper,    key = "z",    fn = launchAppOrFocus("Zed Preview") },
      { mods = appHyper,    key = "v",    fn = launchAppOrFocus("Visual Studio Code") },
      { mods = appHyper,    key = "k",    fn = launchAppOrFocus("Alacritty") },
      { mods = appHyper,    key = "b",    fn = launchAppOrFocus("Safari") },
      { mods = appHyper,    key = "m",    fn = launchAppOrFocus("Activity Monitor") },
      { mods = appHyper,    key = "i",    fn = launchAppOrFocus("Mail") },
      { mods = appHyper,    key = "=",    fn = launchAppOrFocus("Proxyman") },
      { mods = windowHyper, key = "g",    fn = hs.grid.show },
      { mods = windowHyper, key = "r", fn = function()
         hs.console.clearConsole()
         hs.reload()
      end,
      },
   },
   ["Safari"] = {
      { key = "f13",  press = { "tab", { "ctrl", "shift" } } },
      { key = "f14",  press = { "tab", { "ctrl" } } },
      { key = "f15",  press = { "r", { "cmd" } } },
      { key = "f16",  press = { "t", { "cmd", "shift" } } },
      { key = "pad0", press = { "left", { "cmd" } } },
      { key = "pad1", press = { "w", { "cmd" } } },
      { key = "pad2", press = { "right", { "cmd" } } },
      { key = "f20", press = {
         { "right", { "cmd" } },
         10,
         { "right", { "cmd" } },
      } },
   },
   ["Google Chrome"] = {
      { key = "f13",  press = { "tab", { "ctrl", "shift" } } },
      { key = "f14",  press = { "tab", { "ctrl" } } },
      { key = "f15",  press = { "r", { "cmd" } } },
      { key = "f16",  press = { "t", { "cmd", "shift" } } },
      { key = "pad0", press = { "left", { "cmd" } } },
      { key = "pad1", press = { "w", { "cmd" } } },
      { key = "pad2", press = { "right", { "cmd" } }, }
   },
   ["Zed Preview"] = {
      { key = "f13",  press = { "o", { "ctrl" } } },
      { key = "f14",  press = { "i", { "ctrl" } }, },
      { key = "f16",  fn = launchAppOrFocus("Simulator") },
      { key = "pad0", press = { "b", { "cmd" } } },
      { key = "pad2", press = { "r", { "cmd" } } },
      { key = "f20", press = {
         { "r", { "cmd", "shift" } },
         { "b", { "cmd" } },
      } },
   },
   ["Simulator"] = {
      { key = "f16", fn = launchAppOrFocus("Zed Preview") },
   }
}
