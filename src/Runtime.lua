local LuauClass = require(script.Parent.LuauClass)

local Injector = require(script.Parent.Injector)
local Context = require(script.Parent.Context)

local types = require(script.Parent.types)


local Runtime = LuauClass {_type = 'Runtime'} :: types.Runtime

function Runtime:__init(configuration: types.RuntimeConfiguration?)
    local config = configuration or {}

    self.__loop = config.loop or game:GetService('RunService').Heartbeat
    self.__is_running = false

    self.__boxes = {}
    self.__faces = {}
    self.__box_contexts = {}

    self.__middleware = function(face: any) return face end
    self.__injector = Injector.new()

    if config.root_declarations then
        config.root_declarations(self.__injector)
    end
end

function Runtime:add<T>(box: types.Box<T>, declare: ((injector: types.Injector) -> ())??)
    if table.find(self.__boxes, box) then
        error('Box already added to runtime.')
    end

    self.__box_contexts[box] = self:__create_context_for(box, declare or function() end)
    table.insert(self.__boxes, box)
end

function Runtime:remove(box: types.Box<any>)
    local index = table.find(self.__boxes, box)

    if not index then
        error('Box not running.')
    end

    if box:is_running() then
        if self.__box_contexts[box].on_stop then
            self.__box_contexts[box].on_stop()
        end
    
        box:stop()
    end

    self.__box_contexts[box] = nil
    self.__faces[box] = nil
    table.remove(self.__boxes, index)
end

function Runtime:add_middleware(middleware: (face: any) -> any)
    local previous_middleware = self.__middleware

    self.__middleware = function(face: any)
        middleware(face)
        previous_middleware(face)
    end
end

function Runtime:get<T>(box: types.Box<T>): T
    if not self.__faces[box] then
        error('Can\'t get face of that box.')
    end

    return self.__faces[box]
end

function Runtime:__create_context_for<T>(box: T, declare: (injector: types.Injector) -> ()): types.MeowContextTable
    local injector = self.__injector:extend()

    declare(injector)

    return {
        runtime = self,
        injector = injector,

        metadata = {
            box = box
        }
    }
end

function Runtime:__run_box<T>(box: types.Box<T>)
    if not self.__box_contexts[box] then
        error('Meow can\'t find context for box')
    end

    local is_success, face_or_error = Context.run_under(
        self.__box_contexts[box],
        function()
            return pcall(box.run, box)
        end
    )

    if not is_success then
        warn(`Meow box throwed an error:\n{face_or_error}`)
        return
    end

    self.__middleware(face_or_error)
    self.__faces[box] = face_or_error
end

function Runtime:__sort_boxes()
    table.sort(self.__boxes, function(left, right)
        return left.run_order < right.run_order
    end)
end

function Runtime:start()
    if self.__is_running then
        error('Runtime is already started.')
    end

    self:__sort_boxes()

    for _, box in self.__boxes do
        self:__run_box(box)
    end

    for _, context in self.__box_contexts do
        if context.on_start then
            task.spawn(context.on_start)
        end
    end

    local previous_call = tick()

    self.__connection = self.__loop:Connect(function()
        local delta = tick() - previous_call

        previous_call = tick()

        for _, context in self.__box_contexts do
            if context.on_loop then
                task.spawn(context.on_loop, delta)
            end
        end
    end)

    self.__is_running = true
end

function Runtime:stop()
    if not self.__is_running then
        error('Runtime not running.')
    end

    self.__connection:Disconnect()

    for box, context in self.__box_contexts do
        if context.on_stop then
            context.on_stop()
        end

        box:stop()
    end

    self.__faces = {}
    self.__is_running = false
end

return Runtime