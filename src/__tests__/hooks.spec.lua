--!nocheck

return function()
    local Context = require(script.Parent.Parent.Context)
    local Hooks = require(script.Parent.Parent.Hooks)

    local Injector = require(script.Parent.Parent.Injector)
    local Runtime = require(script.Parent.Parent.Runtime)

    it('useMetadata', function()
        local meta = {}
        local result = Context.run_under({
            metadata = meta
        }, function()
            return Hooks.useMetadata()
        end)

        expect(result).to.equal(meta)
        expect(function()
            Hooks.useMetadata()
        end).to.throw()
    end)

    it('useInjector', function()
        local injector = Injector.new()
        local result = Context.run_under({
            injector = injector
        }, function()
            return Hooks.useInjector()
        end)

        expect(result).to.equal(injector)
        expect(function()
            Hooks.useInjector()
        end).to.throw()
    end)

    it('useRuntime', function()
        local runtime = Runtime.new()
        local result = Context.run_under({
            runtime = runtime
        }, function()
            return Hooks.useRuntime()
        end)

        expect(result).to.equal(runtime)
        expect(function()
            Hooks.useRuntime()
        end).to.throw()
    end)

    it('Lifecycle hooks', function()
        local context = {}
        local test = function() end

        Context.run_under(context, function()
            Hooks.useStart(test)
        end)

        Context.run_under(context, function()
            Hooks.useStop(test)
        end)

        Context.run_under(context, function()
            Hooks.useLoop(test)
        end)

        expect(function()
            Hooks.useStop()
        end).to.throw()

        expect(function()
            Hooks.useLoop()
        end).to.throw()

        expect(function()
            Hooks.useStart()
        end).to.throw()

        expect(context.on_start).to.equal(test)
        expect(context.on_loop).to.equal(test)
        expect(context.on_stop).to.equal(test)
    end)
end
