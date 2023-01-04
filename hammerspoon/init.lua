hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall
windowHyper = { 'cmd', 'alt', 'ctrl' }
appHyper = { 'cmd', 'alt', 'ctrl', 'shift' }
hs.mouse.setAbsolutePosition = true
function bind(key, func)
    hs.hotkey.bind(windowHyper, key, func)
end

function positionWindow( x, y, w, h)  
   return function() 
      local win = hs.window.focusedWindow() 
      hs.grid.set(win, hs.geometry.rect(x, y, w, h))       
   end
end   

Install:andUse("AppLauncher", {   
   config = {
      modifiers = appHyper
   },
   hotkeys = {
      x = 'Xcode',
      k = 'Alacritty',
      e = 'Sublime text',
      b = 'Safari',
      m = 'Activity Monitor',
      i = 'Mail',
      p = 'Infuse'
   }
})

hs.grid.setGrid('6x4')

bind("r", hs.reload)
bind("f", hs.grid.maximizeWindow) -- fullscreen
bind("l",  positionWindow({x=3, y=0, w=3, h=4})) -- metade direita
bind("h", positionWindow({x=0, y=0, w=3, h=4})) -- metade esquerda
bind("j", positionWindow({x=0, y=2, w=6, h=2})) -- metade de baixo 
bind("k", positionWindow({x=0, y=0, w=6, h=2})) -- metade de cima
bind("p", positionWindow({x=3, y=0, w=3, h=2})) -- canto superior direito 
bind("y", positionWindow({x=0, y=0, w=3, h=2})) -- canto superior esquero
bind("b", positionWindow({x=0, y=2, w=3, h=2})) -- canto inferior esquero
bind(".", positionWindow({x=3, y=2, w=3, h=2})) -- canto inferior direito
bind("c", positionWindow({x=2, y=1, w=2, h=2})) -- centrazila no meio
bind("g", hs.grid.show)










