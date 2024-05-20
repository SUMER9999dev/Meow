local LuauClass = require(script.Parent.LuauClass)


export type InjectorSymbol<T> = {name: string, default: T?, __LUAU_TYPE_SYSTEM_IS_BEST_THIS_FIELD_DOESNT_EXISTS_DO_NOT_USE_IT: T}


type InjectorInterface = {
    resolve: <T>(self: Injector, symbol: InjectorSymbol<T>) -> T,
    declare: <T>(self: Injector, symbol: InjectorSymbol<T>, declaration: T) -> (),
    extend: (self: Injector) -> Injector,

    __declarations: {[InjectorSymbol<any>]: any},
    __root: Injector?
}
export type Injector = LuauClass.Class<
    InjectorInterface,
    {},
    Injector?
>


export type Context<T> = {
	read: () -> T,
	write: (value: T) -> (),

	run_under: <R>(context: T, callback: () -> R) -> R
}

export type MeowContextTable = {
    runtime: Runtime,
    injector: Injector,

    metadata: {[string]: any},

    on_stop: (() -> ())?,
    on_start: (() -> ())?,
    on_loop: (() -> ())?
}

export type MeowContext = Context<MeowContextTable?>


type BoxInterface<T> = {
    run: (self: Box<T>) -> T,
    stop: (self: Box<T>) -> (),

    is_running: (self: Box<T>) -> boolean,

    run_order: number,

    __is_running: boolean,
    __callback: () -> T
}
export type Box<T> = LuauClass.Class<
    BoxInterface<T>,
    {},
    () -> T
>


type RuntimeInterface = {
    add_middleware: (self: Runtime, middleware: (face: {[any]: any}) -> ()) -> (),

    add: <T>(self: Runtime, box: Box<T>, declare: ((injector: Injector) -> ())?) -> (),
    remove: (self: Runtime, box: Box<any>) -> (),
    get: <T>(self: Runtime, box: Box<T>) -> T,

    start: (self: Runtime) -> (),
    stop: (self: Runtime) -> (),

    __run_box: <T>(self: Runtime, box: Box<T>) -> (),
    __sort_boxes: (self: Runtime) -> (),
    __create_context_for: <T>(self: Runtime, box: T, declare: (injector: Injector) -> ()) -> MeowContextTable,

    __middleware: (face: {[any]: any}) -> {[any]: any},
    __is_running: boolean,

    __box_contexts: {[Box<any>]: MeowContextTable},
    __boxes: {Box<any>},
    __faces: {[Box<any>]: any},

    __injector: Injector,

    __loop: RBXScriptSignal,
    __connection: RBXScriptConnection?
}
export type RuntimeConfiguration = {
    loop: RBXScriptSignal?,
    root_declarations: ((injector: Injector) -> ())?
}
export type Runtime = LuauClass.Class<
    RuntimeInterface,
    {},
    RuntimeConfiguration?
>


return {
    faceof = function<T>(box: Box<T>): T  -- just type helper: type my_box_face = typeof(faceof(my_box))
        return (nil :: any) :: T
    end
}
