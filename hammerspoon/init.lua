hs.loadSpoon("SpoonInstall")
--hs.loadSpoon("LeftRightHotkey")
Install = spoon.SpoonInstall
windowHyper = { 'cmd', 'alt', 'ctrl' }
appHyper = { 'cmd', 'alt', 'ctrl', 'shift' }
mouseHyper = { 'cmd', 'alt', 'ctrl', 'shift' }
moveHyper = { 'rightcmd' }


hs.mouse.setAbsolutePosition = true

hs.window.animationDuration = 0.1


function bind(key, hyper, func)
    hs.hotkey.bind(hyper, key, func)
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
                hs.application.launchOrFocus(appName)
            end)
        end
    end
end

function emacsclient()
    hs.execute("~/.hammerspoon/emacsclientOrEmacs.sh")
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

hs.grid.setGrid('10x4')
hs.grid.ui.textSize = 90
hs.grid.ui.showExtraKeys = true

bind("G", windowHyper, hs.grid.show)

bind("p", appHyper, emacsclient)
bind("x", appHyper, launchAppOrFocus('Xcode'))
bind("k", appHyper, launchAppOrFocus('Alacritty'))
bind("e", appHyper, launchAppOrFocus('Sublime text'))
bind("b", appHyper, launchAppOrFocus('Safari'))
bind("m", appHyper, launchAppOrFocus('Activity Monitor'))
bind("i", appHyper, launchAppOrFocus('Mail'))


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

-- configuração para botões do g604
-- foi configurado no mouse um windowHyper com botões de 0 a 9
-- os botões de clique 1, 2, rolamento e clique do meio continuam sem alterações
-- o atalahos estão setados no mouse da seguinte forma
-- botões laterais de traz para frente: 2,3,4
-- botões laterais de baixo de tr   az para frente: 4,6,7
-- botão + 1
-- botão - 0
-- scroll para esquerda 9
-- scroll para direita 8
bind("1", mouseHyper, hs.spaces.toggleShowDesktop)
bind("5", mouseHyper, hs.spaces.toggleMissionControl)
bind("6", mouseHyper, hs.spaces.toggleAppExpose)
bind("7", mouseHyper, hs.spaces.toggleLaunchPad)




local rightCmdKeyCode = 54 -- Código da tecla Cmd direita

local rightCmdTap = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, function(event)
    -- Verifica se o Cmd direito está pressionado
    local flags = event:getFlags()
    local keyCode = event:getKeyCode()
    local isRightCmd = keyCode == rightCmdKeyCode and flags.cmd

    -- hs.alert.show("pressionado: " .. keyCode)
    if isRightCmd then
        hs.alert.show("Cmd Direito pressionado! " .. hs.inspect.inspect(hs.keycodes.map.a))
        -- Faça algo aqui
    end

    return false -- Não bloqueia o evento
end)

-- Inicia o evento
rightCmdTap:start()
