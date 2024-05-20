local types = require(script.Parent.types)


local function create_context<T>(default: T): types.Context<T>
    local current_context = default

    return {
        write = function(value: T)
            current_context = value
        end,
        read = function()
            return current_context
        end,
        run_under = function<R>(value: T, callback: () -> R): R
            local previous_context = current_context
            local result = {} :: {any}

            current_context = value
            result = {callback()}
            current_context = previous_context

            return unpack(result)
        end
    }
end


return {
    create_context = create_context
}
