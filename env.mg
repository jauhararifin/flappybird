@wasm_import("env", "get_window")
fn get_window(): opaque;

@wasm_import("env", "get_memory")
fn get_memory(): opaque;

@wasm_import("env", "get_property")
fn get_property(obj: opaque, name: opaque): opaque;

@wasm_import("env", "set_property")
fn set_property(obj: opaque, name: opaque, value: opaque): opaque;

@wasm_import("env", "new0")
fn new0(constructor: opaque): opaque;

@wasm_import("env", "new1")
fn new1(constructor: opaque, arg1: opaque): opaque;

@wasm_import("env", "new2")
fn new2(constructor: opaque, arg1: opaque, arg2: opaque): opaque;

@wasm_import("env", "new3")
fn new3(constructor: opaque, arg1: opaque, arg2: opaque, arg3: opaque): opaque;

@wasm_import("env", "call0")
fn call0(this: opaque, f: opaque): opaque;

@wasm_import("env", "call1")
fn call1(this: opaque, f: opaque, arg1: opaque): opaque;

@wasm_import("env", "call2")
fn call2(this: opaque, f: opaque, arg1: opaque, arg2: opaque): opaque;

@wasm_import("env", "call3")
fn call3(this: opaque, f: opaque, arg1: opaque, arg2: opaque, arg3: opaque): opaque;

@wasm_import("env", "call4")
fn call4(this: opaque, f: opaque, arg1: opaque, arg2: opaque, arg3: opaque, arg4: opaque): opaque;

@wasm_import("env", "call5")
fn call5(this: opaque, f: opaque, arg1: opaque, arg2: opaque, arg3: opaque, arg4: opaque, arg5: opaque): opaque;

@wasm_import("env", "call6")
fn call6(this: opaque, f: opaque, arg1: opaque, arg2: opaque, arg3: opaque, arg4: opaque, arg5: opaque, arg6: opaque): opaque;

@wasm_import("env", "string")
fn string(s: [*]u8, len: usize): opaque;

@wasm_import("env", "number")
fn number(n: u64): opaque;

@wasm_import("env", "bool")
fn as_bool(n: bool): opaque;

@wasm_import("env", "int")
fn int(n: opaque): usize;

@wasm_import("env", "debug")
fn debug(n: opaque);
