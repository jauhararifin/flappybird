import js "js";
import state "state";
import scene "scene";

let canvas_width: i64 = 600;
let canvas_height: i64 = 800;
let speed_px_per_sec: f32 = 100.0;
let timestamp: f32 = 0.0;

let s: state::State = state::State{
  width: 600,
  height: 800,
  distance: 0,
  timestamp: 0.0,
};

@wasm_export("on_canvas_resized")
fn on_canvas_resized(new_width: i64, new_height: i64) {
  s.width = new_width;
  s.height = new_height;
  scene::draw_land(s);
}

@wasm_export("on_load")
fn on_load() {
  js::canvas_clear_rect(0, 0, canvas_width, canvas_height);
  scene::draw_land(s);
}

@wasm_export("on_enter_frame")
fn on_enter_frame(ts: f32) {
  s.timestamp = ts;
  s.distance = ((s.timestamp / 1000.0) * speed_px_per_sec) as i64
  scene::draw_grass(s);
}

@wasm_export("on_draw")
fn on_draw() {
  scene::draw_land(s);
}

