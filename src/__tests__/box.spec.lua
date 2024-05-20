return function()
    local Box = require(script.Parent.Parent.Box)

    it('Box', function()
        local box = Box.new(function()
            error('runned!')
        end)

        expect(box:is_running()).to.equal(false)

        expect(function()
            box:run()
        end).to.throw('runned!')

        expect(box:is_running()).to.equal(true)

        expect(function()
            box:run()
        end).to.throw('Box already running.')
    end)

    it('Box face', function()
        local box = Box.new(function()
            return 5
        end)

        expect(box:run()).to.equal(5)
    end)
end