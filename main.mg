import js "js";
import env "env";
import webgl "webgl";
import embed "embed";
import bitmap "bitmap";
import mem "mem";
import base "components/base";
import background "components/background";
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
let background_component: background::Component;

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

  webgl::clear_color(drawer.ctx, 0.439, 0.752941176, 0.803921569, 1.0);
  webgl::clear(drawer.ctx, drawer.ctx.COLOR_BUFFER_BIT);

  background::draw(background_component, s);
  base::draw(base_component, s);
}

fn setup_webgl() {
  window = js::get_window();

  drawer = graphic::setup(window);

  background_component = background::setup(drawer, window);
  background::draw(background_component, s);

  base_component = base::setup(drawer, window);
  base::draw(base_component, s);
}

