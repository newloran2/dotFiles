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

local log = hs.logger.new("mpv", "info")
function mpv(url)
    log.i("mpv() chamada")

    if not url or url == "" then
        log.e("URL não informada")
        hs.notify.new({
            title = "mpv",
            informativeText = "URL não informada"
        }):send()
        return
    end

    log.i("URL recebida: " .. url)

    local socket = "/tmp/mpv-socket"
    log.i("Socket configurado: " .. socket)

    -- 1. Garante que a sessão tmux exista
    log.i("Garantindo sessão tmux 'mpv'")
    hs.execute("tmux has-session -t mpv 2>/dev/null || tmux new-session -d -s mpv")

    -- 2. Verifica se mpv está rodando na sessão tmux
    log.i("Verificando se o mpv está rodando na sessão tmux")
    local mpvRunning = hs.execute(
        "tmux list-panes -t mpv -F '#{pane_pid}' | " ..
        "xargs -I{} pgrep -P {} mpv 2>/dev/null && echo yes"
    )

    -- 3. Verifica se o socket existe
    log.i("Verificando se o socket do mpv existe")
    local socketExists = hs.execute("[ -S " .. socket .. " ] && echo yes")

    log.i(string.format(
        "Estado detectado → mpvRunning=%s socketExists=%s",
        mpvRunning:match("yes") and "yes" or "no",
        socketExists:match("yes") and "yes" or "no"
    ))

    if mpvRunning:match("yes") and socketExists:match("yes") then
        -- 4. mpv rodando → adiciona à playlist via IPC
        log.i("mpv rodando + socket válido, enviando URL via IPC")

        local cmd = string.format(
            "echo '{ \"command\": [\"loadfile\", \"%s\", \"append\"] }' | socat - %s",
            url,
            socket
        )

        log.d("Comando IPC: " .. cmd)
        hs.execute(cmd)
        log.i("URL adicionada à playlist do mpv")
    else
        -- 5. mpv não está rodando corretamente → iniciar
        log.w("mpv não está rodando ou socket inválido, iniciando mpv")

        local cmd = string.format(
            "tmux send-keys -t mpv \"mpv --input-ipc-server=%s '%s'\" C-m",
            socket,
            url
        )

        log.d("Comando tmux: " .. cmd)
        hs.execute(cmd)
        log.i("mpv iniciado na sessão tmux")
    end
end
local mouseTap = nil
local currentMouseDown = {}
function mouse(config)
	mouseTap = hs.eventtap.new(
		{ hs.eventtap.event.types.otherMouseDown, hs.eventtap.event.types.otherMouseUp },
		function(e)
			local btn = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
			local bName = "b" .. btn
			local eventType = e:getType()

			local m = ""
			if eventType == hs.eventtap.event.types.otherMouseDown then
				m = "mouseDown"
			elseif eventType == hs.eventtap.event.types.otherMouseUp then
				m = "mouseUp"
			else
				m = eventType
			end
			if m == "mouseDown" then
				currentMouseDown[bName] = true
				hs.printf("Mouse down = %s", bName)
				return false
			end
			if m == "mouseUp" then
				if currentMouseDown[bName] then
					hs.printf("Mouse up = %s", bName)
					currentMouseDown[bName] = nil
				end
				local c = (config[bName] or {})
				local buttonAloneFunc = c[1] or nil
		
				if buttonAloneFunc then
					hs.printf("buttonAloneFunc = %s", bName)
					local press = c["press"] or nil
					if press and currentMouseDown[press] == nil then						
						return false
					end
					buttonAloneFunc()
					return true
				else
					local frontApp = hs.application.frontmostApplication():name()
					local conf = (config[frontApp] or {})
					local button = conf[bName] or {}
					local func = button[1] or nil
					local c = button["c"] or nil

					-- hs.printf("teste = %s", c)

					if func then
						local press = button["press"] or nil
						if press and currentMouseDown[press] == nil then						
							return false
						end
						func()
						return true
					else
						-- hs.printf("button = %s", bName)
					end
				end
			end
			return false
		end
	)

	mouseTap:start()
end

function Safari()
	launchAppOrFocus("Safari")()
end


function checkYoutubeLinkUnderMouse()
	local mousePoint = hs.mouse.absolutePosition()
	local safari = hs.application.find("Safari")
	if not safari then
		hs.alert.show("Safari não está aberto")
		return
	end
	local win = safari:focusedWindow() or safari:mainWindow()
	if not win then
		hs.alert.show("Nenhuma janela do Safari ativa")
		return
	end
	local axApp = hs.axuielement.applicationElement(safari)
	if not axApp then
		hs.alert.show("Acessibilidade não disponível para o Safari")
		return
	end
	local elem = axApp:elementAtPosition(mousePoint.x, mousePoint.y)
	if not elem then
		hs.alert.show("Nenhum elemento sob o mouse")
		return
	end
	-- Sobe na hierarquia até encontrar um AXURL
	local current = elem
	local url = nil
	while current and not url do
		-- hs.printf("Elemento atual: %s", hs.inspect.inspect(current:allAttributeValues()))
		url = current:attributeValue("AXURL")
		-- hs.printf("URL encontrada: %s", url)
		if url and type(url.url) == "string" and url.url:match("youtube%.com/watch") then
			hs.printf("URL encontrada: %s, %s", type(url.url) == "string", url.url:match("youtube%.com/watch"))
			url = url.url
			break
		end
		current = current:attributeValue("AXParent")
	end
	if url and type(url) == "string" and url:match("youtube%.com/watch") then
		hs.alert.show("Link do YouTube detectado!\n" .. url)
		-- Aqui você pode chamar sua função para tocar no mpv, ex:
		-- runCommand("mpv --profile=yt-mid " .. url)
		-- runCommand("/opt/homebrew/bin/mpv --profile=yt-mid " .. url, function() hs.printf("Tocando link: %s", url) end)
		-- runCommand([[/opt/homebrew/bin/mpv url]])
		-- mpv(url)

	else
		hs.alert.show("Nenhum link do YouTube sob o mouse")
	end
end

function Hammerspoon()
   launchAppOrFocus("Hammerspoon")()
end

-- uma função que verifica se o mouse está em cima de um link de video no youtue e caso verdadeiro tenta tocar esse video no mpv

local mouseConfig = {
	Safari = {
		b3 = { emacsclient, press = "b9" },
		b4 = { Hammerspoon, c = "a", emacsclient, press = "b9" },
		b15 = { keyPress("w", { "cmd" }) },
		b16 = { keyPress("left", { "cmd" }) },
		b17 = { keyPress("right", { "cmd" }) },
		-- b5 = { checkYoutubeLinkUnderMouse },
	},
	Hammerspoon = {
		b3 = { Safari, press = "b9" },
		b17 = { moveAndResizeWindow(0.81, 0.05, 0.2, 0.6) },
	},
	Emacs = {
		b2 = {
			runInSequence({
				keyPress("escape", {}),
				keyPress("up", {}),
			}),
		},
		b3 = { Safari },
		b4 = { Hammerspoon },
		b16 = { positionWindow({ x = 0, y = 0, w = 5, h = 4 }) },
		b17 = { positionWindow({ x = 5, y = 0, w = 5, h = 4 }) },
		b14 = {
			function()
				print("teste")
			end,
		},
	},
}

mouse(mouseConfig)

bind("t", appHyper, launchAppOrFocus("Teams"))
bind("p", appHyper, emacsclient)
bind("x", appHyper, launchAppOrFocus("Xcode"))
bind("k", appHyper, launchAppOrFocus("Alacritty"))
bind("e", appHyper, launchAppOrFocus("Sublime text"))
bind("b", appHyper, launchAppOrFocus("Safari"))
bind("m", appHyper, launchAppOrFocus("Activity Monitor"))
bind("i", appHyper, launchAppOrFocus("Mail"))
bind("=", appHyper, launchAppOrFocus("Proxyman"))
bind("0", appHyper, taskwarriorTui)

-- binds de moviento de janelas
bind("r", windowHyper, function()
	hs.console.clearConsole()
	hs.reload()
end)

bind("f", windowHyper, hs.grid.maximizeWindow) -- fullscreen
bind("l", windowHyper, positionWindow({ x = 5, y = 0, w = 5, h = 4 })) -- metade direita
bind("h", windowHyper, positionWindow({ x = 0, y = 0, w = 5, h = 4 })) -- metade esquerda
bind("j", windowHyper, positionWindow({ x = 0, y = 2, w = 10, h = 2 })) -- metade de baixo
bind("k", windowHyper, positionWindow({ x = 0, y = 0, w = 10, h = 2 })) -- metade de cima
bind("p", windowHyper, positionWindow({ x = 5, y = 0, w = 5, h = 2 })) -- canto superior direito
bind("y", windowHyper, positionWindow({ x = 0, y = 0, w = 5, h = 2 })) -- canto superior esquero
bind("b", windowHyper, positionWindow({ x = 0, y = 2, w = 5, h = 2 })) -- canto inferior esquero
bind(".", windowHyper, positionWindow({ x = 5, y = 2, w = 5, h = 2 })) -- canto inferior direito
bind("c", windowHyper, positionWindow({ x = 2, y = 0, w = 5, h = 4 })) -- centrazila no meio

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
