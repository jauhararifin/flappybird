import js "js";

@wasm_export("on_resize")
fn on_canvas_resized(new_width: i64, new_height: i64) {
}

@wasm_export("on_load")
fn on_load() {
  let window = js::get_window();
  let canvas = js::get_element_by_id(window.document, "canvas");
  let canvas = js::new_canvas(canvas);
  let webgl = js::canvas_get_context(canvas, "webgl");
  js::console_log(window.console, webgl);
}

@wasm_export("on_enter_frame")
fn on_enter_frame(ts: f32) {
}

@wasm_export("on_draw")
fn on_draw() {
}

