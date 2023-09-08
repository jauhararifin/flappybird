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

let vertexShaderSource: [*]u8 = "
  attribute vec2 a_position;
  attribute vec2 a_textcoord;
  uniform mat3 u_transform;
  uniform mat3 u_transform_text;
  varying vec2 v_textcoord;
  void main() {
    gl_Position = vec4(u_transform * vec3(a_position, 1.0), 1);
    v_textcoord = (u_transform_text * vec3(a_textcoord, 1.0)).st;
  }
";

let fragmentShaderSource: [*]u8 = "
  precision mediump float;
  varying vec2 v_textcoord;
  uniform sampler2D u_texture;
  uniform vec2 u_textcoord_translate;
  void main() {
    gl_FragColor = texture2D(u_texture, v_textcoord + u_textcoord_translate);
  }
";

@wasm_export("on_resize")
fn on_canvas_resized(new_width: f32, new_height: f32) {
  s.canvas_width = new_width as f32;
  s.canvas_height = new_height as f32;
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

@wasm_export("on_draw")
fn on_draw() {
}

fn setup_webgl() {
  window = js::get_window();

  drawer = graphic::setup(window);
  base_component = base::setup(drawer, window);
  base::draw(base_component, s);
}

