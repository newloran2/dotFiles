local this = {}
this.__index = this
this.name = "MouseHandler"

this.mouseTap = nil
this.currentMouseDown = {}
this.longpressDuration = 0.6
this.doubleClickDuration = 0.4
this.longPressTasks = {}
this.debug = false

function inspect(item)
    return hs.inspect.inspect(item)
end


function this.mouseEventyType(e)
    if e == hs.eventtap.event.types.otherMouseDown then
        return "mouseDown"
    elseif e == hs.eventtap.event.types.otherMouseUp then
        return "mouseUp"
    else
        return ""
    end
end

function this.handletLongPress(bName, func)
    local task = hs.timer.doAfter(this.longpressDuration,
        function()
            
            if this.currentMouseDown[bName] then
                if this.debug then
                    hs.printf("long press action executed %s" , hs.inspect.inspect(this.currentMouseDown) )                   
                end
                func()
                this.longPressTasks[bName].executed = true
            end
        end
    )
    this.longPressTasks[bName] = {taks = task, executed = false}
    task:start()
end

function this.cancelLongPress(bName)
    local task = this.longPressTasks[bName]
    if task then
        this.longPressTasks[bName] = nil
        task.taks:stop()        
        if this.debug  then
            hs.printf("long press cancelled %s" , bName )
        end 
    end
end


function this:start2(config)
    if self.mouseTap then
        self.mouseTap:stop()
        self.mouseTap = nil
    end
    self.currentMouseDown = {}
    self.mouseTap = hs.eventtap.new(
        { hs.eventtap.event.types.otherMouseDown, hs.eventtap.event.types.otherMouseUp },
        function(e)
            local btn = e:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)
            local frontApp = hs.application.frontmostApplication():name()
            local bName = "b" .. btn            
            local eventType = e:getType()
            local m = this.mouseEventyType(eventType)
            if m == "mouseDown" then
                self.currentMouseDown[bName] = true
                local c = (config[frontApp] or {})
                local b = c[bName] or {}
                local longPress = b["longPress"] or {}
                local longPressFunc = longPress[1] or nil
                if longPressFunc then
                    this.handletLongPress(bName, longPressFunc)
                end     
                return true 
            end
            if m == "mouseUp" then                
                if self.currentMouseDown[bName] then
                    self.currentMouseDown[bName] = nil
                end
                local c = (config[frontApp] or {})
                local b = c[bName] or {}
                local click = b["click"] or {}
                local clickFunc = click[1] or nil
                if this.debug then
                    hs.printf("mouse up detected %s b = %s %s %s", bName , inspect(click), inspect(this.longPressTasks), this.debug )
                end
                if clickFunc then                    
                    if this.longPressTasks[bName] and this.longPressTasks[bName].executed then
                        this.cancelLongPress(bName)
                        return true
                    end
                    if clickFunc then
                        local press = click["press"] or nil
                        if press and self.currentMouseDown[press] == nil then
                            return true
                        end
                        this.cancelLongPress(bName)
                        clickFunc()      
                        return true
                    end
                end
            end
            return false
        end
    )
    self.mouseTap:start()
end

function this:stop()
    if self.mouseTap then
        self.mouseTap:stop()
        self.mouseTap = nil
    end
    self.currentMouseDown = {}
end

return this
