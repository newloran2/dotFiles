local this = {}
this.__index = this
this.name = "EShortcuts"

this.debug = false
local appHotkeys = {}
local globalHotkeys = {}
local globalHotkeyMap = {}
local lastAppName = nil


local lastCmdPressTime = 0
local cmdDoubleTapThreshold = 0.3 -- Janela de tempo para o segundo clique (em segundos)
local cmdIsHeldAfterDoubleTap = false

hs.hotkey.setLogLevel(2)


-- Monitora mudanças nas teclas modificadoras (Flags)
cmdMonitor = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
   local flags = event:getFlags()
   local keyCode = event:getKeyCode()

   -- O KeyCode 55 é o Command Esquerdo no Mac
   if keyCode == 55 then
      local now = hs.timer.secondsSinceEpoch()

      -- 1. DETECTA O PRESSIONAMENTO (KeyDown do Cmd)
      if flags.cmd then
         local diff = now - lastCmdPressTime

         if diff < cmdDoubleTapThreshold then
            -- É um Double Tap!
            cmdIsHeldAfterDoubleTap = true
            if this.debug then
               hs.alert.show("Cmd Double Hold: ATIVO ⚡️")
            end


            -- Acione sua função de "Início" aqui
            -- ex: abrir um overlay, iniciar redimensionamento, etc.
         end

         lastCmdPressTime = now

         -- 2. DETECTA A SOLTURA (KeyUp do Cmd)
      else
         if cmdIsHeldAfterDoubleTap then
            cmdIsHeldAfterDoubleTap = false
            if this.debug then
               hs.alert.show("Cmd Double Hold: SOLTO")
            end

            -- Acione sua função de "Finalização" aqui
            return true -- Opcional: bloqueia o evento para o sistema não processar o Cmd solto
         end
      end
   end

   return false
end):start()

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

local function shortcutKey(mods, key)
   return table.concat(mods, "-") .. "+" .. key
end

local function normalizeMods(mods)
   mods = mods or {}
   local order = { cmd = 1, alt = 2, ctrl = 3, shift = 4 }
   table.sort(mods, function(a, b) return order[a] < order[b] end)
   return mods
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
-- função que dispara um keypress
-- parametro key é a tecla que sera pressionada
-- parametro mods são os modificadores que devem ser pressionados junto com a tecla
local function keyPress(key, mods)
   return function() hs.eventtap.keyStroke(mods, key) end
end


local function pressAndShift(press, shift)
   return function()
      if cmdIsHeldAfterDoubleTap then
         local shiftFunc = type(shift) == "function" and shift or
             (type(shift) == "table" and keyPress(shift[1], shift[2]) or function() end)
         shiftFunc()
      else
         local pressFunc = type(press) == "function" and press or
             (type(press) == "table" and keyPress(press[1], press[2]) or function() end)
         pressFunc()
      end
   end
end

local function action(param)
   local paramTye = type(param)
   if paramTye == "function" then
      return param
   end

   return pressAndShift(param.press, param.shift)
end


function this:bind(config)
   if config["*"] then
      for _, bind in ipairs(config["*"]) do
         local mods = normalizeMods(bind.mods)
         local fn = action(bind.action)
         local hk
         if this.debug then
            hs.printf("binding global %s + %s", table.concat(mods, "+"), bind.key)
            -- hk = hs.hotkey.new(mods, bind.key, "global", nil, fn)
            hk = hs.hotkey.new(mods, bind.key, nil, fn)
         else
            hk = hs.hotkey.new(mods, bind.key, nil, fn)
         end

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
            local fn = action(bind.action)

            local hk
            if this.debug then
               hk = hs.hotkey.new(mods, bind.key, "app", fn)
               -- hk = hs.hotkey.new(mods, bind.key, nil, fn)
            else
               hk = hs.hotkey.new(mods, bind.key, nil, fn)
            end

            table.insert(appHotkeys[app], { hk = hk, mods = mods, key = bind.key })
            hk:disable()
         end
      end
   end
end

hs.application.watcher.new(updateHotkeys):start()

return this
