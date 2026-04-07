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

-- função que executa uma serie de funções em sequencia
-- posso passar um tempo para esperar entre cada função
local function runInSequence(funcs, delay)
   if delay == nil then
      return function()
         hs.printf("Executando funções em sequência sem delay")
         for _, func in ipairs(funcs) do
            hs.printf("Executando função %s", func)
            func()
         end
      end
   end
   return function()
      hs.printf("Executando funções em sequência com delay de %f segundos", delay)
      for i, func in ipairs(funcs) do
         hs.timer.doAfter(delay, func)
      end
   end
end

-- função que dispara um keypress
-- parametro key é a tecla que sera pressionada
-- parametro mods são os modificadores que devem ser pressionados junto com a tecla
local function keyPress(key, mods)
   return function() hs.eventtap.keyStroke(mods, key) end
end

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



function positionWindow(x, y, w, h)
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

function moveWindow(direction)
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
function moveAndResizeWindow(x, y, w, h)
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


local function launchOrCycle(appName)
   return function()
      local app = hs.application.get(appName)

      if not app then
         hs.application.launchOrFocus(appName)
         return
      end

      if not app:isFrontmost() then
         app:activate()
         return
      end

      local allWindows = hs.window.orderedWindows()
      local appWindows = {}

      for _, win in ipairs(allWindows) do
         if win:application():name() == appName and win:isStandard() then
            table.insert(appWindows, win)
         end
      end

      if #appWindows <= 1 then return end

      local current = hs.window.frontmostWindow()

      for i, win in ipairs(appWindows) do
         if win:id() == current:id() then
            local nextIndex = (i % #appWindows) + 1
            appWindows[nextIndex]:focus()
            return
         end
      end
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

local function execute(command)
   return function()
      hs.execute(command)
   end
end

local shortcuts = hs.loadSpoon("EShortcuts")
shortcuts.debug = false
shortcuts:bind {
   ["*"] = {
      -- { mods = windowHyper, key = "f",    action = maximize },
      { mods = windowHyper, key = "h",     action = left },
      { mods = windowHyper, key = "l",     action = right },
      { mods = { "cmd" },   key = "pad0",  action = left },
      { mods = { "shift" }, key = "pad2",  action = right },
      { mods = windowHyper, key = "k",     action = up },
      { mods = windowHyper, key = "j",     action = down },
      { mods = windowHyper, key = "y",     action = topLeft },
      { mods = windowHyper, key = "p",     action = topRight },
      { mods = windowHyper, key = "b",     action = bottomLeft },
      { mods = windowHyper, key = ".",     action = bottomRight },
      { mods = windowHyper, key = "c",     action = center },
      { mods = windowHyper, key = "f",     action = maximize },

      { mods = { "cmd" },   key = "f13",   action = { shift = hs.spaces.toggleMissionControl } },
      { mods = { "cmd" },   key = "f14",   action = { shift = left } },
      { mods = { "cmd" },   key = "f15",   action = { shift = right } },
      { mods = { "cmd" },   key = "f16",   action = { shift = maximize } },



      { mods = windowHyper, key = "right", action = moveWindow("right") },
      { mods = windowHyper, key = "left",  action = moveWindow("left") },
      { mods = windowHyper, key = "up",    action = moveWindow("up") },
      { mods = windowHyper, key = "down",  action = moveWindow("down") },
      -- { mods = windowHyper, key = "=",    action = nextMonitor() },

      { mods = appHyper,    key = "p",     action = emacsclient },
      { mods = appHyper,    key = "t",     action = launchAppOrFocus("Teams") },
      { mods = appHyper,    key = "a",     action = launchAppOrFocus("Android Studio") },
      { mods = appHyper,    key = "x",     action = launchAppOrFocus("Xcode") },
      { mods = appHyper,    key = "z",     action = launchAppOrFocus("Zed Preview") },
      { mods = appHyper,    key = "v",     action = launchAppOrFocus("Visual Studio Code") },
      { mods = appHyper,    key = "k",     action = launchAppOrFocus("Alacritty") },
      { mods = appHyper,    key = "b",     action = launchAppOrFocus("Safari") },
      { mods = appHyper,    key = "m",     action = launchAppOrFocus("Activity Monitor") },
      { mods = appHyper,    key = "i",     action = launchAppOrFocus("Mail") },
      { mods = appHyper,    key = "=",     action = launchAppOrFocus("Proxyman") },
      { mods = windowHyper, key = "g",     action = hs.grid.show },
      { mods = windowHyper, key = "r", action = function()
         hs.console.clearConsole()
         hs.reload()
      end,
      },
   },
   ["Proxyman"] = {
      { key = "f16", action = launchAppOrFocus("Simulator") },
      { key = "f17", action = launchAppOrFocus("Xcode") },
      { key = "pad1", action = runInSequence({
         keyPress("a", { "cmd" }),
         keyPress("k", { "cmd" }),
      }, 0.2) },
   },
   ["Safari"] = {
      { key = "f13",  action = { press = { "tab", { "ctrl", "shift" } } } },
      { key = "f14",  action = { press = { "tab", { "ctrl" } } } },
      { key = "f15",  action = { press = { "r", { "cmd" } } } },
      { key = "f16",  action = { press = { "t", { "cmd", "shift" } } } },
      { key = "pad0", action = { press = { "left", { "cmd" } } } },
      { key = "pad1", action = { press = { "w", { "cmd" } } } },
      { key = "pad2", action = { press = { "right", { "cmd" } } } },
   },
   ["Google Chrome"] = {
      { key = "f13",  action = { press = { "tab", { "ctrl", "shift" } } } },
      { key = "f14",  action = { press = { "tab", { "ctrl" } } } },
      { key = "f15",  action = { press = { "r", { "cmd" } } } },
      { key = "f16",  action = { press = { "t", { "cmd", "shift" } } } },
      { key = "pad0", action = { press = { "left", { "cmd" } } } },
      { key = "pad1", action = { press = { "w", { "cmd" } } } },
      { key = "pad2", action = { press = { "right", { "cmd" } } } },
   },
   ["Zed Preview"] = {
      { key = "f13", action = { press = { "o", { "ctrl" } } } },
      { key = "f14", action = { press = { "i", { "ctrl" } }, } },
      { key = "f16", action = launchAppOrFocus("Simulator") },
      { key = "f19", action = { press = { "escape", { "shift" } } } },
      { mods = { "cmd" },
         key = "f16",
         action = {
            press = { "b", { "cmd" } },
            double = hs.spaces.toggleMissionControl,
            shift = { "r", { "cmd" } },

         }
      },
      { key = "f20",  action = { press = { "`", { "ctrl", "shift" } } } },
      { key = "pad0", action = { press = { "b", { "cmd" } } } },

      { key = "pad1", action = runInSequence(
         {
            keyPress("`", { "ctrl", "shift" }),
            keyPress("k", { "cmd" }),
            keyPress("`", { "ctrl", "shift" }),
         }),
      },
      { key = "pad2", action = { press = { "r", { "cmd" } } } },
   },
   ["Xcode"] = {
      { key = "pad0",     action = { press = { "1", { "cmd", "ctrl" } } } },
      { key = "pad1",     action = { press = { "k", { "cmd" } } } },
      { key = "pad2",     action = { press = { "9", { "cmd", "ctrl" } } } },
      { key = "f13",      action = { press = { "left", { "cmd", "ctrl" } } } },
      { key = "f14",      action = { press = { "right", { "cmd", "ctrl" } } } },
      { key = "f16",      action = launchAppOrFocus("Simulator") },
      { key = "f17",      action = launchAppOrFocus("Proxyman") },
      { key = "f18",      action = { press = { "r", { "cmd" } } } },
      { mods = { "cmd" }, key = "f18",                                        action = { press = { ".", { "cmd" } } } },
   },
   ["Simulator"] = {
      { key = "f16", action = launchAppOrFocus("Xcode") },
      { key = "f17", action = launchAppOrFocus("Proxyman") },
      { key = "f18", action = runInSequence({
         launchAppOrFocus("Xcode"),
         keyPress("r", { "cmd" }),
         launchAppOrFocus("Simulator"),
      }, 0.2) },
      { mods = { "cmd" }, key = "f18", action = runInSequence({
         launchAppOrFocus("Xcode"),
         keyPress(".", { "cmd" }),
         launchAppOrFocus("Simulator"),
      }, 0.2) },

      { key = "pad1", action = runInSequence({
         launchAppOrFocus("Xcode"),
         keyPress("k", { "cmd" }),
         launchAppOrFocus("Simulator"),
      }, 0.2) },

      -- { key = "f18",  action = execute("~/.local/bin/reload_app_in_ios_emulator USR2") },
      -- { key = "f18",  action = execute("~/.local/bin/reload_app_in_ios_emulator USR2") },
      { key = "pad0", action = moveAndResizeWindow(0.005, 0, 1, 0.6) },
      { key = "pad2", action = moveAndResizeWindow(0.85, 0, 1, 0.6) },
   }
}
