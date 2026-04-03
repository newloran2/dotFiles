local this = {}
this.__index = this
this.name = "EShortcuts"

this.debug = false
local appHotkeys = {}
local globalHotkeys = {}
local globalHotkeyMap = {}
local lastAppName = nil




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
local function keyPress(key, mods, application)
   local app = nil
   if application ~= nil then
      app = hs.application.get(application)
   end
   return function() hs.eventtap.keyStroke(mods, key, 200, app) end
end




function this:bind(config)
   if config["*"] then
      for _, bind in ipairs(config["*"]) do
         local mods = normalizeMods(bind.mods)
         local fn
         if bind.press ~= nil then
            fn = keyPress(bind.press[1], bind.press[2])
         else
            fn = bind.fn
         end
         local hk = hs.hotkey.new(mods, bind.key, fn)
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
            local fn
            if bind.press ~= nil then
               fn = keyPress(bind.press[1], bind.press[2])
            else
               fn = bind.fn
            end
            local hk = hs.hotkey.new(mods, bind.key, fn)
            table.insert(appHotkeys[app], { hk = hk, mods = mods, key = bind.key })
            hk:disable()
         end
      end
   end
   hs.application.watcher.new(updateHotkeys):start()
end

return this
