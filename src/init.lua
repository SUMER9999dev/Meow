local Box = require(script.Box)
local Runtime = require(script.Runtime)
local Hooks = require(script.Hooks)
local Decorators = require(script.Decorators)
local InjectorSymbol = require(script.InjectorSymbol)

local types = require(script.types)


export type Box<T> = types.Box<T>
export type MeowContext = types.MeowContext


return {
    Box = function<T>(callback: () -> T): types.Box<T>
        return Box.new(callback)
    end,

    Runtime = function(configuration: types.RuntimeConfiguration?): types.Runtime
        return Runtime.new(configuration)
    end,

    useInjector = Hooks.useInjector,
    useRuntime = Hooks.useRuntime,
    useLoop = Hooks.useLoop,
    useStart = Hooks.useStart,
    useStop = Hooks.useStop,
    useMetadata = Hooks.useMetadata,

    Decorate = Decorators.Decorate,
    Depends = Decorators.Depends,
    Named = Decorators.Named,
    RunOrder = Decorators.RunOrder,

    InjectorSymbol = InjectorSymbol,

    faceof = types.faceof
}
