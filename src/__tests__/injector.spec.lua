return function()
    local Injector = require(script.Parent.Parent.Injector)
    local InjectorSymbol = require(script.Parent.Parent.InjectorSymbol)

    it('injector declare', function()
        local injector = Injector.new()
        local test = InjectorSymbol('test', 'nothing')

        injector:declare(test, 'Hello world!')

        expect(injector:resolve(test)).to.equal('Hello world!')
    end)

    it('injector extend', function()
        local injector = Injector.new()
        local child_injector = injector:extend()

        expect(child_injector).to.be.ok()
        expect(child_injector.__root).to.equal(injector)
    end)

    it('injector child declare', function()
        local injector = Injector.new()
        local child_injector = injector:extend()

        local root = InjectorSymbol('root', ((nil :: any) :: number))
        local child = InjectorSymbol('child', ((nil :: any) :: number))

        injector:declare(root, 1)
        child_injector:declare(child, 2)

        expect(child_injector:resolve(root)).to.equal(1)
        expect(child_injector:resolve(child)).to.equal(2)
    end)

    it('injector unknown resolve', function()
        local injector = Injector.new()

        expect(function()
            injector:resolve('unknown')
        end).to.throw()
    end)
end
