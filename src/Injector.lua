local LuauClass = require(script.Parent.LuauClass)
local types = require(script.Parent.types)


local Injector = LuauClass {_type = 'Injector'} :: types.Injector

function Injector:__init(root: types.Injector?)
    self.__root = root
    self.__declarations = {}
end

function Injector:declare<T>(symbol: types.InjectorSymbol<T>, declaration: T)
    self.__declarations[symbol] = declaration
end

function Injector:extend(): types.Injector
    return Injector.new(self)
end

function Injector:resolve<T>(symbol: types.InjectorSymbol<T>): T
    local child_declaration = self.__declarations[symbol]

    if child_declaration then
        return child_declaration
    end

    if self.__root then
        return self.__root:resolve(symbol)
    end

    if symbol.default ~= nil then
        return symbol.default
    end

    return error(`Failed to resolve {symbol.name}.`)
end

return Injector
