return function()
    local Hooks = require(script.Parent.Parent.Hooks)
    local Decorators = require(script.Parent.Parent.Decorators)

    local Box = require(script.Parent.Parent.Box)
    local Runtime = require(script.Parent.Parent.Runtime)

    it('Named', function()
        local runtime = Runtime.new()

        local metadata = {name = nil}
        local box = Box.new(function() metadata = Hooks.useMetadata() end)

        Decorators.Named(box, 'test')

        runtime:add(box)
        runtime:start()
        runtime:stop()

        expect(metadata.name).to.equal('test')
    end)

    it('Depends', function()
        local runtime = Runtime.new()

        local injector = nil

        local box_2 = Box.new(function() return {test = 1} end)
        local box = Box.new(function() injector = Hooks.useInjector() end)

        Decorators.Depends(box, {a = box_2})

        runtime:add(box_2)
        runtime:add(box)

        runtime:start()
        runtime:stop()

        expect(injector:resolve('a').test).to.equal(1)
    end)

    it('Decorate', function()
        local box = Box.new(function() end)

        Decorators.Decorate(box, function()
            error('abc')
        end)

        expect(function()
            box:run()
        end).to.throw('abc')
    end)

    it('RunOrder', function()
        local box = Box.new(function() end)
        Decorators.RunOrder(box, 2)

        expect(box.run_order).to.equal(2)
    end)
end
