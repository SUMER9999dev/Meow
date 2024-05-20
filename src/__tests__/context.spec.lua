return function()
    local Context = require(script.Parent.Parent.Context)
    local Injector = require(script.Parent.Parent.Injector)
    local Runtime = require(script.Parent.Parent.Runtime)

    it('Context', function()
        local pseudo_context = {
            injector = Injector.new(),
            runtime = Runtime.new(),

            metadata = {}
        }

        local result = Context.run_under(pseudo_context, function()
            return Context.read()
        end)

        expect(result).to.equal(pseudo_context)
    end)
end