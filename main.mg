import js "js";
import env "env";
import webgl "webgl";
import embed "embed";
import bitmap "bitmap";
import mem "mem";
import base "base";
import graphic "graphic";
import state "state";

let window: js::Window;
let s: state::State = state::State{
  stage: state::STAGE_READY,

  canvas_width: 600.0,
  canvas_height: 600.0,

  gameover_ts: 0.0,
  start_ts: 0.0,
  now: 0.0,
};

let drawer: graphic::Drawer;
let base_component: base::Component;

@wasm_export("on_resize")
fn on_canvas_resized(new_width: f32, new_height: f32) {
  s.canvas_width = new_width as f32;
  s.canvas_height = new_height as f32;

  webgl::viewport(drawer.ctx, 0, 0, s.canvas_width as i32, s.canvas_height as i32);
}

@wasm_export("on_load")
fn on_load() {
  setup_webgl();
}

@wasm_export("on_enter_frame")
fn on_enter_frame(ts: f32) {
  s.now = ts;
  base::draw(base_component, s);
}

fn setup_webgl() {
  window = js::get_window();

  drawer = graphic::setup(window);
  base_component = base::setup(drawer, window);
  base::draw(base_component, s);
}

