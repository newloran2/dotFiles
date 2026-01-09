hs.loadSpoon("SpoonInstall")
--hs.loadSpoon("LeftRightHotkey")
Install = spoon.SpoonInstall
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


function bind(key, hyper, func)
    hs.hotkey.bind(hyper, key, func)
end

--função para criar bind de mouse 
-- com 3 parametros button recebe o numero do botao do mouse 
-- pressedButton recebe um botão do mouse que deve estar pressionado enquando button é pressionado pode ser nulo, caso seja nulo o bind funciona com apenas o button for pressionado
-- app recebe o nome do app que o bind deve funcionar, caso seja nulo funciona globalmente
-- func é a função que sera executada quanndo o bind for acionado

-- mouse(button, pressedButton, app, fun, isLongPress, numClicks)
-- isLongPress: se true, faz long press no último clique (default: false)
-- numClicks: número de cliques a detectar antes de acionar (default: 1)
function mouse(button, pressedButton, app, fun, isLongPress, numClicks, alertText)

    isLongPress = isLongPress or false
    numClicks = numClicks or 1
    local clickCount = 0
    local lastClickTime = 0
    local mouseDownTime = 0
    local clickTimeout = 0.2 -- tempo máximo entre cliques para considerar sequência
    local singleClickTimer = nil
    local mouseTap
    mouseTap = hs.eventtap.new(
        { hs.eventtap.event.types.otherMouseDown, hs.eventtap.event.types.otherMouseUp },
        function(e)
            local btn = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)            
            local eventType = e:getType()
            local frontApp = hs.application.frontmostApplication():name()
            local now = hs.timer.secondsSinceEpoch()
            if btn == button and (pressedButton == nil or hs.eventtap.checkMouseButtons()[pressedButton + 1]) and (app == nil or app == frontApp) then
                if eventType == hs.eventtap.event.types.otherMouseDown then
                    if now - lastClickTime > clickTimeout then
                        clickCount = 1
                    else
                        clickCount = clickCount + 1
                    end
                    lastClickTime = now
                    if clickCount == numClicks then
                        mouseDownTime = now
                    end
                    return false
                elseif eventType == hs.eventtap.event.types.otherMouseUp then
                    if clickCount == numClicks then
                        local heldTime = now - mouseDownTime
                        if isLongPress and heldTime > 0.5 then
                            fun()
                            print("botao: " .. btn)
                            if alertText ~= nil then
                                hs.alert.show(alertText)
                            end
                            clickCount = 0
                        elseif not isLongPress and heldTime <= 0.5 then
                            if numClicks == 1 then
                                -- Adia o single click se houver handler de double click
                                if singleClickTimer then
                                    singleClickTimer:stop()
                                    singleClickTimer = nil
                                end
                                singleClickTimer = hs.timer.doAfter(clickTimeout, function()
                                    -- Só executa se não houve segundo clique
                                    if clickCount == 1 then
                                        fun()
                                        print("botao: " .. btn)
                                        if alertText ~= nil then
                                            hs.alert.show(alertText)
                                        end
                                    end
                                    clickCount = 0
                                    singleClickTimer = nil
                                end)
                            else
                                fun()
                                print("botao: " .. btn)
                                if alertText ~= nil then
                                    hs.alert.show(alertText)
                                end
                                clickCount = 0
                            end
                        elseif not isLongPress and numClicks > 1 and heldTime <= 0.5 then
                            fun()
                            print("botao: " .. btn)
                            if alertText ~= nil then
                                hs.alert.show(alertText)
                            end
                            clickCount = 0
                        end
                    end
                end
            else
                clickCount = 0
                if singleClickTimer then
                    singleClickTimer:stop()
                    singleClickTimer = nil
                end
            end
            return false
        end
    )
    mouseTap:start()
end


-- função que dispara um keypress 
-- parametro key é a tecla que sera pressionada
-- parametro mods são os modificadores que devem ser pressionados junto com a tecla
function keyPress(key, mods)
    return function() hs.eventtap.keyStroke(mods, key) end
end


-- função que executa uma serie de funções em sequencia 
-- posso passar um tempo para esperar entre cada função
function runInSequence(funcs, delay)
    delay = delay or 0.01
    return function()
        for i, func in ipairs(funcs) do
            hs.timer.doAfter((i - 1) * delay, func)
        end
    end
end


function positionWindow(x, y, w, h)
    -- o posiocionamento funciona da seguinte forma
    -- o gid configurado sendo 9x4
    -- x pode ser de 0 a 9 se passar do tamanho maximo considera o tamanho maximo
    -- y a mesma logica do x
    -- h e w são a altura e a largura e se aplicam na mesma logica de x
    return function()
        hs.printf("position window chamado")
        local win = hs.window.focusedWindow()
        hs.grid.set(win, hs.geometry.rect(x, y, w, h))
    end
end

function resizeWindow(direction)
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

-- move uma janela para a posição position e redimensiona para size

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


-- Função para executar um comando de linha de comando
function runCommand(command, callback)
    hs.task.new("/bin/bash", function()
        if callback then
            callback()
        end
    end, function(task, stdout, stderr)
        -- hs.alert.show("Command executed: " .. command)
        -- hs.alert.show("Output: " .. stdout)
        -- hs.alert.show("Error: " .. stderr)
    end, { "-c", command }):start()
end

function focusOrExecute(appName, command)
    return function()
        local app = hs.application.find(appName)
        if app then
            local window = app:mainWindow()
            if window then
                hs.application.launchOrFocus(appName)
            else
                runCommand(command, function()
                    hs.application.launchOrFocus(appName)
                end)
            end
        else
           runCommand(command, function()
                if appName ~= nil then
                   hs.application.launchOrFocus(appName)
                else
                   return true
                end
            end)
        end
    end
end

function emacsclient()
    hs.execute("~/.hammerspoon/emacsclientOrEmacs.sh")
end
function taskwarriorTui()
    runCommand([[ /opt/homebrew/bin/alacritty -e /bin/zsh -l -c '/opt/homebrew/bin/taskwarrior-tui' ]])
end

function playYoutubeLink()
    local button, text = hs.dialog.textPrompt(
        "Youtube URL",
        "entre sua url",
        "",
        "Tocar",
        "Cancelar"
    )

    if button == "Tocar" and text ~= "" then
        runCommnad("mpv --profile=yt-mid " .. text, function() end)
    end
end

function scroll(position, mods)
    local scrollEvent = hs.eventtap.event.newScrollEvent({ -1, 0 }, {}, "pixel")
    scrollEvent:post()
end

function launchAppOrFocus(app)
    return function()
        hs.application.launchOrFocus(app)
    end
end

hs.grid.ui.showExtraKeys = false
hs.grid.setGrid('10x4')
hs.grid.ui.textSize = 30

bind("G", windowHyper, hs.grid.show)

bind("p", appHyper, emacsclient)
bind("x", appHyper, launchAppOrFocus('Xcode'))
bind("k", appHyper, launchAppOrFocus('Alacritty'))
bind("e", appHyper, launchAppOrFocus('Sublime text'))
bind("b", appHyper, launchAppOrFocus('Safari'))
bind("m", appHyper, launchAppOrFocus('Activity Monitor'))
bind("i", appHyper, launchAppOrFocus('Mail'))
bind("=", appHyper, launchAppOrFocus('Proxyman'))
bind("0", appHyper, taskwarriorTui)


-- binds de moviento de janelas
bind("r", windowHyper, function()
    hs.console.clearConsole()
    hs.reload()
end)


bind("f", windowHyper, hs.grid.maximizeWindow)                          -- fullscreen
bind("l", windowHyper, positionWindow({ x = 5, y = 0, w = 5, h = 4 }))  -- metade direita
bind("h", windowHyper, positionWindow({ x = 0, y = 0, w = 5, h = 4 }))  -- metade esquerda
bind("j", windowHyper, positionWindow({ x = 0, y = 2, w = 10, h = 2 })) -- metade de baixo
bind("k", windowHyper, positionWindow({ x = 0, y = 0, w = 10, h = 2 })) -- metade de cima
bind("p", windowHyper, positionWindow({ x = 5, y = 0, w = 5, h = 2 }))  -- canto superior direito
bind("y", windowHyper, positionWindow({ x = 0, y = 0, w = 5, h = 2 }))  -- canto superior esquero
bind("b", windowHyper, positionWindow({ x = 0, y = 2, w = 5, h = 2 }))  -- canto inferior esquero
bind(".", windowHyper, positionWindow({ x = 5, y = 2, w = 5, h = 2 }))  -- canto inferior direito
bind("c", windowHyper, positionWindow({ x = 2, y = 0, w = 5, h = 4 }))  -- centrazila no meio

bind("-", windowHyper, resizeWindow("up"))
bind("=", windowHyper, resizeWindow("down"))
bind("left", windowHyper, resizeWindow("left"))
bind("right", windowHyper, resizeWindow("right"))


bind("right", moveHyper, moveWindow("right"))
bind("left", moveHyper, moveWindow("left"))
bind("up", moveHyper, moveWindow("up"))
bind("down", moveHyper, moveWindow("down"))
--bind para limpar o console do hammerspoon e recarregar a configuração
bind("r", windowHyper, function()
    hs.console.clearConsole()
    hs.reload()
end)


-- mouse binds

function echoDesktop()
    hs.spaces.toggleShowDesktop()
end


--mouse(button, pressedButton, app, fun)
-- mouse(9, 3, "Alacritty", echoDesktop)
mouse(2,  nil, "Xcode",  keyPress("K", {"cmd"}))
mouse(4,  nil, "Xcode",  keyPress(".", {"cmd"}), false, 2, "stop")
-- mouse(4,  nil, "Xcode",  function() print("teste") end, false, 1, "teste")
mouse(4,  nil, "Xcode",  function() print("zica") end, true, 2, "zica")
mouse(4,  nil, "Xcode",  keyPress("r", {"cmd"}), true, 1 , "run")
mouse(5,  nil, "Xcode",  launchAppOrFocus('Simulator'))
mouse(8,  nil, "Xcode",  launchAppOrFocus('Proxyman'))
mouse(11, nil, "Xcode",  keyPress("Y", {"cmd", "shift"}))
mouse(12, nil, "Xcode",  launchAppOrFocus('Safari'))

mouse(2,  nil, "Simulator", runInSequence({ launchAppOrFocus('Xcode'), keyPress("K", {"cmd"}), launchAppOrFocus('Simulator'),}))
mouse(4,  nil, "Simulator", runInSequence({ launchAppOrFocus('Xcode'), keyPress("r", {"cmd"}), launchAppOrFocus('Simulator'),}, 0.5), true, 1, "run simulator")
mouse(4,  nil, "Simulator", runInSequence({ launchAppOrFocus('Xcode'), keyPress(".", {"cmd"}), launchAppOrFocus('Simulator'),}, 0.2), false, 2, "stop simulator")
mouse(5,  nil, "Simulator",  launchAppOrFocus('Xcode'))
mouse(16, nil, "Simulator", moveAndResizeWindow(0.01, 0.3, 0.2, 0.6))
mouse(17, nil, "Simulator", moveAndResizeWindow(0.81, 0.3, 0.2, 0.6))
mouse(8, nil, "Proxyman",  launchAppOrFocus('Xcode'))
-- mouse(5, nil, "Proxyman",  launchAppOrFocus('Simulator'))

mouse(16,  nil, 'Safari',  keyPress("left", {"cmd"})) -- pagina anterior
mouse(17,  nil, 'Safari',  keyPress("right", {"cmd"})) -- pagina seguinte
mouse(3,  9, 'Safari',  keyPress("tab", {"ctrl", "shift"})) -- proxima aba
mouse(4,  9, 'Safari',  keyPress("tab", {"ctrl"})) -- aba anterior