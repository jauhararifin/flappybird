@wasm_import("env", "canvas_clear_rect")
fn canvas_clear_rect(x: i64, y: i64, width: i64, height: i64);

@wasm_import("env", "canvas_set_fill_style")
fn canvas_set_fill_style(str: JsString);

@wasm_import("env", "canvas_set_stroke_style")
fn canvas_set_stroke_style(str: JsString);

@wasm_import("env", "canvas_set_line_width")
fn canvas_set_line_width(width: i64);

@wasm_import("env", "canvas_fill_rect")
fn canvas_fill_rect(x: i64, y: i64, width: i64, height: i64);

@wasm_import("env", "canvas_stroke_rect")
fn canvas_stroke_rect(x: i64, y: i64, width: i64, height: i64);

@wasm_import("env", "debug_i64")
fn debug_i64(val: i64);

@wasm_import("env", "debug_f32")
fn debug_f32(val: f32);

struct JsString {
  start: [*]u8,
  len: usize,
}

fn new_js_string(color: [*]u8): JsString {
  let len = strlen(color);
  return JsString {
    start: color,
    len: len,
  };
}

fn strlen(str: [*]u8): usize {
  let len: usize = 0;
  while str[len].* != 0 {
    len = len + 1;
  }
  return len;
}
