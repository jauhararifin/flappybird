import env "env";
import js "js";
import webgl "webgl";
import mem "mem";
import base "components/base";
import background "components/background";
import bird "components/bird";
import pipe "components/pipe";
import score "components/score";
import graphic "graphic";
import state "state";

let window: js::Window;
let s: *state::State;

let drawer: graphic::Drawer;
let base_component: base::Component;
let background_component: background::Component;
let bird_component: bird::Component;
let pipe_component: pipe::Component;
let score_component: score::Component;

@wasm_export("on_load")
fn on_load() {
  window = js::get_window();

  setup_state();
  setup_webgl();

  on_canvas_resized(null);

  js::add_event_listener(window, "resize", on_canvas_resized);
}

@wasm_export("on_resize")
fn on_canvas_resized(arguments: opaque): opaque {
  setup_state();

  let canvas = js::get_element_by_id(window.document, "canvas");
  let new_width = env::int(env::get_property(window.inner, js::str("innerWidth")));
  let new_height = env::int(env::get_property(window.inner, js::str("innerHeight")));
  env::set_property(canvas, js::str("width"), env::number(new_width as u64));
  env::set_property(canvas, js::str("height"), env::number(new_height as u64));

  state::resize(s, new_width as f32, new_height as f32);
  webgl::viewport(drawer.ctx, 0, 0, s.canvas_width.* as i32, s.canvas_height.* as i32);

  return null;
}

@wasm_export("on_click")
fn on_canvas_clicked() {
  setup_state();
  state::tap(s);
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
  pipe::draw(pipe_component, s.*);
  base::draw(base_component, s.*);
  score::draw(score_component, s.*);
  bird::draw(bird_component, s.*);

  let bounding_boxes = pipe::get_bounding_boxes(pipe_component);
  let base_box = base::get_bounding_box(base_component);
  let bird_box = bird::get_bounding_box(bird_component);
  state::check_collision(s, bird_box, base_box, bounding_boxes);
}

fn setup_webgl() {
  drawer = graphic::setup(window);

  background_component = background::setup(drawer, window);
  background::draw(background_component, s.*);

  pipe_component = pipe::setup(drawer, window);
  pipe::draw(pipe_component, s.*);

  base_component = base::setup(drawer, window);
  base::draw(base_component, s.*);

  score_component = score::setup(drawer, window);
  score::draw(score_component, s.*);

  bird_component = bird::setup(drawer, window);
  bird::draw(bird_component, s.*);
}

