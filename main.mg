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
  canvas_width: 600.0,
  canvas_height: 600.0,
};

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
}

@wasm_export("on_draw")
fn on_draw() {
}

fn setup_webgl() {
  window = js::get_window();

  let drawer = graphic::setup(window);
  let base_component = base::setup(drawer, window);
  base::draw(base_component, s);
}

fn create_shader(ctx: webgl::RenderingContext, shader_type: opaque, source: [*]u8): webgl::Shader {
  let shader = webgl::create_shader(ctx, shader_type);
  webgl::shader_source(ctx, shader, source);
  webgl::compile_shader(ctx, shader);
  return shader;
}

fn create_program(ctx: webgl::RenderingContext, vertexShader: webgl::Shader, fragmentShader: webgl::Shader): webgl::Program {
  let program = webgl::create_program(ctx);
  webgl::attach_shader(ctx, program, vertexShader);
  webgl::attach_shader(ctx, program, fragmentShader);
  webgl::link_program(ctx, program);
  return program;
}
