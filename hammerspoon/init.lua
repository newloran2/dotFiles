
windowHyper = { 'shift', 'alt', 'ctrl' }
appHyper = { 'cmd', 'alt', 'ctrl', 'shift' }
mouseHyper = { 'cmd', 'alt', 'ctrl', 'shift' }
moveHyper = { 'alt', 'cmd' }



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



local function normalizeMods(mods)
   local order = { cmd = 1, alt = 2, ctrl = 3, shift = 4 }
   table.sort(mods, function(a, b) return order[a] < order[b] end)
   return mods
end
local lastAppName = nil

local function bind(config)
   local appHotkeys = {}
   local globalHotkeys = {}
   local globalHotkeyMap = {}

   local function shortcutKey(mods, key)
      return table.concat(mods, "-") .. "+" .. key
   end

   if config["*"] then
      for _, bind in ipairs(config["*"]) do
         local mods = normalizeMods(bind.mods)
         local hk = hs.hotkey.new(mods, bind.key, bind.fn)
         local keyStr = shortcutKey(mods, bind.key)
         globalHotkeyMap[keyStr] = hk
         table.insert(globalHotkeys, { hk = hk, mods = mods, key = bind.key })
         hk:enable()
      end
   end

   for app, binds in pairs(config) do
      if app ~= "*" then
         appHotkeys[app] = {}
         for _, bind in ipairs(binds) do
            local mods = normalizeMods(bind.mods)
            local hk = hs.hotkey.new(mods, bind.key, bind.fn)
            table.insert(appHotkeys[app], { hk = hk, mods = mods, key = bind.key })
            hk:disable()
         end
      end
   end

   local function updateHotkeys(appName, eventType)
      if eventType == hs.application.watcher.activated then
         -- Desativa atalhos do app anterior
         if lastAppName and appHotkeys[lastAppName] then
            for _, b in ipairs(appHotkeys[lastAppName]) do
               b.hk:disable()
            end
         end

         -- Ativa atalhos do app atual
         local appBinds = appHotkeys[appName] or {}

         -- Desativa globais que conflitam
         local conflicts = {}
         for _, appBind in ipairs(appBinds) do
            local keyStr = shortcutKey(appBind.mods, appBind.key)
            if globalHotkeyMap[keyStr] then
               globalHotkeyMap[keyStr]:disable()
               conflicts[keyStr] = true
            end
            appBind.hk:enable()
         end

         -- Ativa globais que não conflitam
         for _, g in ipairs(globalHotkeys) do
            local keyStr = shortcutKey(g.mods, g.key)
            if not conflicts[keyStr] then
               g.hk:enable()
            end
         end

         lastAppName = appName
      end
   end

   hs.application.watcher.new(updateHotkeys):start()
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

-- função que dispara um keypress
-- parametro key é a tecla que sera pressionada
-- parametro mods são os modificadores que devem ser pressionados junto com a tecla
local function keyPress(key, mods, application)
   return function() hs.eventtap.keyStroke(mods, key, 200, application) end
end

-- função que executa uma serie de funções em sequencia
-- posso passar um tempo para esperar entre cada função
local function runInSequence(funcs, delay)
   delay = delay or 0.01
   return function()
      for i, func in ipairs(funcs) do
         hs.timer.doAfter((i - 1) * delay, func)
      end
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

function scroll(position, mods)
   local scrollEvent = hs.eventtap.event.newScrollEvent({ -1, 0 }, {}, "pixel")
   scrollEvent:post()
end

local function launchAppOrFocus(app)
   return function()
      hs.application.launchOrFocus(app)
   end
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
local function maximize() positionWindow({ x = 0, y = 0, w = 10, h = 10  })() end

bind {
   ["*"] = {
      { mods = {"cmd"},          key = "f13", fn = hs.spaces.toggleMissionControl },

      { mods = windowHyper, key = "f",    fn = maximize },
      { mods = windowHyper, key = "h",    fn = left },
      { mods = windowHyper, key = "l",    fn = right },
      { mods = { "cmd" },   key = "pad0", fn = left },
      { mods = { "cmd" },   key = "pad2", fn = right },
      { mods = windowHyper, key = "k",    fn = up },
      { mods = windowHyper, key = "j",    fn = down },
      { mods = windowHyper, key = "y",    fn = topLeft },
      { mods = windowHyper, key = "p",    fn = topRight },
      { mods = windowHyper, key = "b",    fn = bottomLeft },
      { mods = windowHyper, key = ".",    fn = bottomRight },
      { mods = windowHyper, key = "c",    fn = center },

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
      end
      },
   },
   ["Safari"] = {
      { mods = {}, key = "f13",  fn = keyPress("tab", { "ctrl", "shift" }) },
      { mods = {}, key = "f14",  fn = keyPress("tab", { "ctrl" }) },
      { mods = {}, key = "f15",  fn = keyPress("r", { "cmd" }) },
      { mods = {}, key = "pad0", fn = keyPress("left", { "cmd" }) },
      { mods = {}, key = "pad1", fn = keyPress("w", { "cmd" }) },
      { mods = {}, key = "pad2", fn = keyPress("right", { "cmd" }) },

   },
   ["Zed Preview"] = {
      { mods = {}, key = "f13",  fn = keyPress("o", { "ctrl" }) },
      { mods = {}, key = "f14",  fn = keyPress("i", { "ctrl" }) },
      { mods = {}, key = "pad0", fn = keyPress("b", { "cmd" }) },
      { mods = {}, key = "pad2", fn = keyPress("r", { "cmd" }) },
   },
}
