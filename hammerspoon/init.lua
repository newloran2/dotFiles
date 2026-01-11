hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall
Install:andUse("GridTile")

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

-- função que dispara um keypress
-- parametro key é a tecla que sera pressionada
-- parametro mods são os modificadores que devem ser pressionados junto com a tecla
function keyPress(key, mods, application)    
    return function() hs.eventtap.keyStroke(mods, key, 200, application) end
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

-- bind("G", windowHyper, hs.grid.show)
hs.hotkey.bind(windowHyper, "G", function()
    spoon.GridTile:start()
end)



local mouseTap = nil

function mouse(config)
    mouseTap = hs.eventtap.new(
        { hs.eventtap.event.types.otherMouseDown, hs.eventtap.event.types.otherMouseUp },
        function(e)
            local btn = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
            local bName = "b"..btn
            local eventType = e:getType()

            local m = ""
            if eventType == hs.eventtap.event.types.otherMouseDown then
                m = "mouseDown"
            elseif eventType == hs.eventtap.event.types.otherMouseUp then
                m = "mouseUp"
            else
                m = eventType
            end
            if m == "mouseUp" then
                local buttonAloneFunc = ((config[bName]) or {})[1] or nil

                if buttonAloneFunc then
                    hs.printf("Buttonalone = %s", buttonAloneFunc)
                    buttonAloneFunc()
                    return true
                else
                    local frontApp = hs.application.frontmostApplication():name()
                    local conf = (config[frontApp] or {})
                    local button = conf[bName] or {}
                    local func = button[1] or nil
                    local func2 = button[2] or nil
                    local c = button['c'] or nil

                    hs.printf("teste = %s", c)

                    if func then
                        func()
                        return true
                    else
                        hs.printf("button = %s", bName)
                    end
                end
            end
            return false
        end
    )

    mouseTap:start()
end



function Safari()
    launchAppOrFocus('Safari')()
end

function Hammerspoon()
    launchAppOrFocus('Hammerspoon')()
end


local mouseConfig = {
    Safari = {
        b3 = { emacsclient },
        b4 = { Hammerspoon, c = "a", emacsclient },
        b15 = { keyPress("w",{"cmd"})},
        b16 = { keyPress("left" , {"cmd"})},
        b17 = { keyPress("right", { "cmd" }) },

    },
    Hammerspoon = {
        b3 = { Safari },
        b17 = {moveAndResizeWindow(0.81, 0.05, 0.2, 0.6)}
    },
    Emacs = {
        b2 = {
            runInSequence{
                keyPress("escape", {}),
                keyPress("up", {})
            }
        },
        b3 = { Safari },
        b4 = { Hammerspoon },
        b16 = {positionWindow({ x = 0, y = 0, w = 5, h = 4 })},
        b17= {positionWindow({ x = 5, y = 0, w = 5, h = 4 })},
        b14 = {function() print("teste") end}
    }

}

mouse(mouseConfig)



bind("t", appHyper, launchAppOrFocus('Teams'))
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
