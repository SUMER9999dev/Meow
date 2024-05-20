local LuauClass = require(script.Parent.LuauClass)
local types = require(script.Parent.types)


local Box = LuauClass {_type = 'Box'} :: types.Box<any>

function Box:__init(callback: () -> any)
    self.__callback = callback
    self.__is_running = false

    self.run_order = 1
end

function Box:run(): any
    if self:is_running() then
        error('Box already running.')
    end

    self.__is_running = true
    return self.__callback()
end

function Box:stop()
    self.__is_running = false
end

function Box:is_running(): boolean
    return self.__is_running
end

return Box