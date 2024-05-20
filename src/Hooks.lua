local Context = require(script.Parent.Context)
local types = require(script.Parent.types)


local Hooks = {}


Hooks.useInjector = function(): types.Injector
    local context = Context.read()

    if not context then
        error('Meow can\'t use hooks out of box.')
    end

    return context.injector
end

Hooks.useRuntime = function(): types.Runtime
    local context = Context.read()

    if not context then
        error('Meow can\'t use hooks out of box.')
    end

    return context.runtime
end

Hooks.useStart = function(callback: () -> ())
    local context = Context.read()

    if not context then
        error('Meow can\'t use hooks out of box.')
    end

    context.on_start = callback
end

Hooks.useStop = function(callback: () -> ())
    local context = Context.read()

    if not context then
        error('Meow can\'t use hooks out of box.')
    end

    context.on_stop = callback
end

Hooks.useLoop = function(callback: (delta: number) -> ())
    local context = Context.read()

    if not context then
        error('Meow can\'t use hooks out of box.')
    end

    context.on_loop = callback
end

Hooks.useMetadata = function(): {[string]: any}
    local context = Context.read()

    if not context then
        error('Meow can\'t use hooks out of box.')
    end

    return context.metadata
end

return Hooks