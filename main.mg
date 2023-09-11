import js "js";
import webgl "webgl";
import mem "mem";
import base "components/base";
import background "components/background";
import bird "components/bird";
import graphic "graphic";
import state "state";

let window: js::Window;
let s: *state::State;

let drawer: graphic::Drawer;
let base_component: base::Component;
let background_component: background::Component;
let bird_component: bird::Component;

@wasm_export("on_resize")
fn on_canvas_resized(new_width: f32, new_height: f32) {
  setup_state();
  state::resize(s, new_width, new_height);
  webgl::viewport(drawer.ctx, 0, 0, s.canvas_width.* as i32, s.canvas_height.* as i32);
}

@wasm_export("on_click")
fn on_canvas_clicked() {
  setup_state();
  state::tap(s);
}

@wasm_export("on_load")
fn on_load() {
  setup_state();
  setup_webgl();
}

fn setup_state() {
  if s as usize != 0 {
    return;
  }

  s = mem::alloc::<state::State>();
  s.* = state::State{
    stage: state::STAGE_READY,

    canvas_width: 600.0,
    canvas_height: 600.0,

    gameover_ts: 0.0,
    start_ts: 0.0,
    now: 0.0,

    y: 0.0,
    speed: 0.0,
  };
}

@wasm_export("on_enter_frame")
fn on_enter_frame(ts: f32) {
  setup_state();
  state::tick(s, ts);

  webgl::clear_color(drawer.ctx, 0.439, 0.752941176, 0.803921569, 1.0);
  webgl::clear(drawer.ctx, drawer.ctx.COLOR_BUFFER_BIT);

  background::draw(background_component, s.*);
  base::draw(base_component, s.*);
  bird::draw(bird_component, s.*);
}

fn setup_webgl() {
  window = js::get_window();

  drawer = graphic::setup(window);

  background_component = background::setup(drawer, window);
  background::draw(background_component, s.*);

  base_component = base::setup(drawer, window);
  base::draw(base_component, s.*);

  bird_component = bird::setup(drawer, window);
  bird::draw(bird_component, s.*);
}

