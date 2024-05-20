local Hooks = require(script.Parent.Hooks)
local types = require(script.Parent.types)


local Decorators = {}

Decorators.Decorate = function(box: types.Box<any>, decorator: () -> ())
    local previous_callback = box.__callback

    box.__callback = function()
        local is_success, exception = pcall(decorator)

        if not is_success then
            error(`Decorator throwed an error: {exception}`)
        end

        return previous_callback()
    end
end

Decorators.Named = function(box: types.Box<any>, name: string)
    Decorators.Decorate(box, function()
        local metadata = Hooks.useMetadata()
        metadata.name = name
    end)
end

Decorators.RunOrder = function(box: types.Box<any>, order: number)
    box.run_order = order
end

Decorators.Depends = function<T>(box: types.Box<any>, dependencies: {[types.InjectorSymbol<T>]: types.Box<T>})
    local order = 0

    for _, dependency in dependencies do
        if order <= dependency.run_order then
            order = dependency.run_order + 1
        end
    end

    Decorators.RunOrder(box, order)

    Decorators.Decorate(box, function()
        local runtime = Hooks.useRuntime()
        local injector = Hooks.useInjector()

        for symbol, box in dependencies do
            local is_success, face = pcall(runtime.get, runtime, box)

            if not is_success then
                error(`Depends failed to get {symbol.name} dependency, are you sure that run order correct?`)
            end

            injector:declare(symbol, face)
        end
    end)
end

return Decorators
