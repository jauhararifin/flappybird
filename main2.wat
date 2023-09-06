(module
  (type (;0;) (func (param i64 i64)))
  (type (;1;) (func))
  (type (;2;) (func (param f32)))
  (type (;3;) (func (result externref externref externref externref externref)))
  (type (;4;) (func (param externref externref i32) (result externref)))
  (type (;5;) (func (param externref externref externref)))
  (type (;6;) (func (param externref) (result externref)))
  (type (;7;) (func (param externref i32) (result externref)))
  (type (;8;) (func (param i32) (result externref)))
  (type (;9;) (func (result externref)))
  (type (;10;) (func (param externref externref) (result externref)))
  (type (;11;) (func (param externref externref externref) (result externref)))
  (type (;12;) (func (param externref externref externref externref) (result externref)))
  (type (;13;) (func (param externref externref externref externref externref) (result externref)))
  (type (;14;) (func (param externref externref externref externref externref externref) (result externref)))
  (type (;15;) (func (param externref externref externref externref externref externref externref) (result externref)))
  (type (;16;) (func (param externref externref externref externref externref externref externref externref) (result externref)))
  (type (;17;) (func (param i32 i32) (result externref)))
  (type (;18;) (func (param i64) (result externref)))
  (type (;19;) (func (param externref) (result i32)))
  (type (;20;) (func (param externref)))
  (import "env" "get_window" (func $env.get_window (type 9)))
  (import "env" "get_property" (func $env.get_property (type 10)))
  (import "env" "set_property" (func $env.set_property (type 11)))
  (import "env" "call1" (func $env.call1 (type 11)))
  (import "env" "call2" (func $env.call2 (type 12)))
  (import "env" "call3" (func $env.call3 (type 13)))
  (import "env" "call4" (func $env.call4 (type 14)))
  (import "env" "call5" (func $env.call5 (type 15)))
  (import "env" "call6" (func $env.call6 (type 16)))
  (import "env" "string" (func $env.string (type 17)))
  (import "env" "number" (func $env.number (type 18)))
  (import "env" "int" (func $env.int (type 19)))
  (import "env" "debug" (func $env.debug (type 20)))
  (func $main.mg.on_canvas_resized (type 0) (param i64 i64))
  (func $main.mg.on_load (type 1)
    (local externref externref externref externref externref externref externref externref externref externref)
    call $js.get_window
    local.set 4
    local.set 3
    local.set 2
    local.set 1
    local.set 0
    local.get 0
    local.get 1
    local.get 2
    local.get 3
    local.get 4
    drop
    drop
    local.set 9
    local.set 8
    drop
    local.get 8
    local.get 9
    i32.const 8
    call $js.get_element_by_id
    local.set 5
    local.get 5
    call $js.new_canvas
    local.set 6
    local.get 6
    i32.const 15
    call $js.canvas_get_context
    local.set 7)
  (func $main.mg.on_enter_frame (type 2) (param f32))
  (func $main.mg.on_draw (type 1))
  (func $js.get_window (type 3) (result externref externref externref externref externref)
    (local externref externref externref externref externref externref externref externref externref)
    call $env.get_window
    local.set 0
    local.get 0
    i32.const 21
    call $js.str
    call $env.get_property
    ref.null extern
    local.set 2
    local.set 1
    local.get 1
    local.get 2
    drop
    local.set 8
    local.get 8
    i32.const 30
    call $js.str
    call $env.get_property
    local.set 3
    local.get 3
    local.set 2
    local.get 0
    i32.const 45
    call $js.str
    call $env.get_property
    local.set 4
    local.get 4
    ref.null extern
    local.set 6
    local.set 5
    local.get 5
    local.get 6
    drop
    local.set 8
    local.get 8
    i32.const 53
    call $js.str
    call $env.get_property
    local.set 7
    local.get 7
    local.set 5
    local.get 5
    local.get 6
    drop
    local.set 8
    local.get 8
    call $env.debug
    local.get 0
    local.get 1
    local.get 2
    local.get 5
    local.get 6
    return)
  (func $js.get_element_by_id (type 4) (param externref externref i32) (result externref)
    (local externref)
    local.get 0
    local.get 1
    drop
    local.set 3
    local.get 3
    local.get 0
    local.get 1
    local.set 3
    drop
    local.get 3
    local.get 2
    call $js.str
    call $env.call1
    return)
  (func $js.console_log (type 5) (param externref externref externref)
    (local externref)
    local.get 0
    local.get 1
    drop
    local.set 3
    local.get 3
    call $env.debug
    local.get 2
    call $env.debug
    local.get 0
    local.get 1
    drop
    local.set 3
    local.get 3
    local.get 0
    local.get 1
    local.set 3
    drop
    local.get 3
    local.get 2
    call $env.call1
    drop)
  (func $js.new_canvas (type 6) (param externref) (result externref)
    local.get 0
    return)
  (func $js.canvas_get_context (type 7) (param externref i32) (result externref)
    (local externref externref)
    local.get 0
    local.set 3
    local.get 3
    i32.const 57
    call $js.str
    call $env.get_property
    local.set 2
    local.get 0
    local.set 3
    local.get 3
    local.get 2
    local.get 1
    call $js.str
    call $env.call1
    return)
  (func $js.str (type 8) (param i32) (result externref)
    (local i32)
    i32.const 0
    local.set 1
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        i32.const 1
        local.get 1
        i32.mul
        i32.add
        i32.load8_u
        i32.const 0
        i32.eq
        i32.eqz
        i32.eqz
        br_if 1 (;@1;)
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        br 0 (;@2;)
      end
    end
    local.get 0
    local.get 1
    call $env.string
    return)
  (func $__init (type 1))
  (table (;0;) 23 funcref)
  (memory (;0;) 1)
  (export "on_resize" (func $main.mg.on_canvas_resized))
  (export "on_load" (func $main.mg.on_load))
  (export "on_enter_frame" (func $main.mg.on_enter_frame))
  (export "on_draw" (func $main.mg.on_draw))
  (export "memory" (memory 0))
  (start $__init)
  (elem (;0;) (i32.const 0) func $env.get_window)
  (elem (;1;) (i32.const 1) func $env.get_property)
  (elem (;2;) (i32.const 2) func $env.set_property)
  (elem (;3;) (i32.const 3) func $env.call1)
  (elem (;4;) (i32.const 4) func $env.call2)
  (elem (;5;) (i32.const 5) func $env.call3)
  (elem (;6;) (i32.const 6) func $env.call4)
  (elem (;7;) (i32.const 7) func $env.call5)
  (elem (;8;) (i32.const 8) func $env.call6)
  (elem (;9;) (i32.const 9) func $env.string)
  (elem (;10;) (i32.const 10) func $env.number)
  (elem (;11;) (i32.const 11) func $env.int)
  (elem (;12;) (i32.const 12) func $env.debug)
  (elem (;13;) (i32.const 13) func $main.mg.on_canvas_resized)
  (elem (;14;) (i32.const 14) func $main.mg.on_load)
  (elem (;15;) (i32.const 15) func $main.mg.on_enter_frame)
  (elem (;16;) (i32.const 16) func $main.mg.on_draw)
  (elem (;17;) (i32.const 17) func $js.get_window)
  (elem (;18;) (i32.const 18) func $js.get_element_by_id)
  (elem (;19;) (i32.const 19) func $js.console_log)
  (elem (;20;) (i32.const 20) func $js.new_canvas)
  (elem (;21;) (i32.const 21) func $js.canvas_get_context)
  (elem (;22;) (i32.const 22) func $js.str)
  (data (;0;) (i32.const 8) "canvas\00")
  (data (;1;) (i32.const 15) "webgl\00")
  (data (;2;) (i32.const 21) "document\00")
  (data (;3;) (i32.const 30) "getElementById\00")
  (data (;4;) (i32.const 45) "console\00")
  (data (;5;) (i32.const 53) "log\00")
  (data (;6;) (i32.const 57) "getContext\00"))
