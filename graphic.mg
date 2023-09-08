import webgl "webgl";
import js "js";

struct Drawer {
  ctx: webgl::RenderingContext,
  positionAttributeLocation: webgl::AttribLocation,
  textcoordAttributeLocation: webgl::AttribLocation,
  transformUniform: webgl::UniformLocation,
  transformTextUniform: webgl::UniformLocation,
  textureUniform: webgl::UniformLocation,
  textCoordTranslateUniform: webgl::UniformLocation,
}

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

fn setup(window: js::Window): Drawer {
  let canvas = js::new_canvas(js::get_element_by_id(window.document, "canvas"));
  let ctx = webgl::get_context(canvas);

  webgl::pixel_storei(ctx, ctx.UNPACK_FLIP_Y_WEBGL, 1);
  webgl::blend_func(ctx, ctx.SRC_ALPHA, ctx.ONE_MINUS_SRC_ALPHA);
  webgl::enable(ctx, ctx.BLEND);

  let vertexShader = create_shader(ctx, ctx.VERTEX_SHADER, vertexShaderSource);
  let fragmentShader = create_shader(ctx, ctx.FRAGMENT_SHADER, fragmentShaderSource);
  let program = create_program(ctx, vertexShader, fragmentShader);
  webgl::use_program(ctx, program);

  let positionAttributeLocation = webgl::get_attrib_location(ctx, program, "a_position");
  let textcoordAttributeLocation = webgl::get_attrib_location(ctx, program, "a_textcoord");
  let transformUniform = webgl::get_uniform_location(ctx, program, "u_transform");
  let transformTextUniform = webgl::get_uniform_location(ctx, program, "u_transform_text");
  let textureUniform = webgl::get_uniform_location(ctx, program, "u_texture");
  let textCoordTranslateUniform = webgl::get_uniform_location(ctx, program, "u_textcoord_translate");

  webgl::enable_vertex_attrib_array(ctx, positionAttributeLocation);
  webgl::enable_vertex_attrib_array(ctx, textcoordAttributeLocation);

  return Drawer {
    ctx: ctx,
    positionAttributeLocation: positionAttributeLocation,
    textcoordAttributeLocation: textcoordAttributeLocation,
    transformUniform: transformUniform,
    transformTextUniform: transformTextUniform,
    textureUniform: textureUniform,
    textCoordTranslateUniform: textCoordTranslateUniform,
  };
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
