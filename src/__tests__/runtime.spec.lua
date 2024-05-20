return function()
    local Runtime = require(script.Parent.Parent.Runtime)
    local Box = require(script.Parent.Parent.Box)
    local Hooks = require(script.Parent.Parent.Hooks)
    local Decorators = require(script.Parent.Parent.Decorators)
    local InjectorSymbol = require(script.Parent.Parent.InjectorSymbol)

    it('basic test', function()
        local test_box = Box.new(function()
            return {4, Hooks.useInjector()}
        end)

        local box_version = InjectorSymbol('Box Version', 0)
        local version = InjectorSymbol('Version', 0)

        local runtime = Runtime.new({
            loop = game:GetService('RunService').Heartbeat,
            root_declarations = function(injector) injector:declare(version, 2) end
        })

        runtime:add(test_box, function(injector)
            injector:declare(box_version, 1)
        end)

        runtime:start()

        expect(runtime:get(test_box)).to.be.ok()
        expect(runtime:get(test_box)[1]).to.equal(4)

        expect(runtime:get(test_box)[2]).to.be.ok()

        local injector = runtime:get(test_box)[2]

        expect(injector:resolve(version)).to.equal(2)
        expect(injector:resolve(box_version)).to.equal(1)

        runtime:stop()
    end)

    it('run order', function()
        local runtime = Runtime.new()
        local first = 0

        local box_1 = Box.new(function()
            if first == 0 then
                first = 1
            end
        end)

        local box_2 = Box.new(function()
            if first == 0 then
                first = 2
            end
        end)

        Decorators.RunOrder(box_2, 2)

        runtime:add(box_1)
        runtime:add(box_2)

        runtime:start()

        expect(first).to.equal(1)

        first = 0
        runtime:stop()

        Decorators.RunOrder(box_1, 3)
        runtime:start()

        expect(first).to.equal(2)

        runtime:stop()
    end)

    it('remove', function()
        local runtime = Runtime.new()

        local box_1 = Box.new(function()
            return {1}
        end)

        runtime:add(box_1)
        runtime:start()

        runtime:remove(box_1)

        expect(box_1:is_running()).to.equal(false)
        expect(function()
            print(runtime:get(box_1))
        end).to.throw()

        runtime:stop()
        runtime:start()

        expect(box_1:is_running()).to.equal(false)

        runtime:stop()
    end)

    it('middleware', function()
        local test_box = Box.new(function()
            return {4}
        end)

        local runtime = Runtime.new({
            loop = game:GetService('RunService').Heartbeat
        })

        runtime:add(test_box, function() end)

        runtime:start()
        expect(runtime:get(test_box)[1]).to.equal(4)
        runtime:stop()

        runtime:add_middleware(function(face)
            if face[1] == 4 then
                face[1] = 5
            end
        end)

        runtime:start()
        expect(runtime:get(test_box)[1]).to.equal(5)
        runtime:stop()
    end)
end