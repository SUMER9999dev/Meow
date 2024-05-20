-- Luau type system is healthy and good
--!nocheck

local types = require(script.Parent.types)


local function createInjectorSymbol<T>(name: string, default: T?): types.InjectorSymbol<T>
    return {name = name, default = default}
end


return createInjectorSymbol