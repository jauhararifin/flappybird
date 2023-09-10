import js "js";
import env "env";

struct RenderingContext {
  inner: opaque,

  pixelStorei: opaque,
  blendFunc: opaque,
  enable: opaque,
  createShader: opaque,
  shaderSource: opaque,
  compileShader: opaque,
  createProgram: opaque,
  attachShader: opaque,
  linkProgram: opaque,
  useProgram: opaque,
  getAttribLocation: opaque,
  getUniformLocation: opaque,
  enableVertexAttribArray: opaque,
  createTexture: opaque,
  bindTexture: opaque,
  texImage2D: opaque,
  createBuffer: opaque,
  bindBuffer: opaque,
  bufferData: opaque,
  vertexAttribPointer: opaque,
  texParameteri: opaque,
  drawArrays: opaque,
  uniformMatrix3fv: opaque,
  uniform1i: opaque,
  uniform2fv: opaque,
  getError: opaque,
  viewport: opaque,
  clearColor: opaque,
  clear: opaque,

  UNPACK_FLIP_Y_WEBGL: opaque,
  SRC_ALPHA: opaque,
  ONE_MINUS_SRC_ALPHA: opaque,
  BLEND: opaque,
  VERTEX_SHADER: opaque,
  FRAGMENT_SHADER: opaque,
  TEXTURE_2D: opaque,
  RGBA: opaque,
  UNSIGNED_BYTE: opaque,
  ARRAY_BUFFER: opaque,
  STATIC_DRAW: opaque,
  FLOAT: opaque,
  TEXTURE_WRAP_S: opaque,
  TEXTURE_WRAP_T: opaque,
  CLAMP_TO_EDGE: opaque,
  TEXTURE_MIN_FILTER: opaque,
  TEXTURE_MAG_FILTER: opaque,
  NEAREST: opaque,
  REPEAT: opaque,
  TRIANGLES: opaque,
  COLOR_BUFFER_BIT: opaque,
}

struct Shader {
  inner: opaque,
}

struct Program {
  inner: opaque,
}

struct AttribLocation {
  inner: opaque,
}

struct UniformLocation {
  inner: opaque,
}

struct Texture {
  inner: opaque,
}

struct Buffer {
  inner: opaque,
}

fn get_context(canvas: js::Canvas): RenderingContext {
  let ctx = RenderingContext{
    inner: js::canvas_get_context(canvas, "webgl"),
  };

  ctx.pixelStorei = env::get_property(ctx.inner, js::str("pixelStorei"));
  ctx.blendFunc = env::get_property(ctx.inner, js::str("blendFunc"));
  ctx.enable = env::get_property(ctx.inner, js::str("enable"));
  ctx.createShader = env::get_property(ctx.inner, js::str("createShader"));
  ctx.shaderSource = env::get_property(ctx.inner, js::str("shaderSource"));
  ctx.compileShader = env::get_property(ctx.inner, js::str("compileShader"));
  ctx.createProgram = env::get_property(ctx.inner, js::str("createProgram"));
  ctx.attachShader = env::get_property(ctx.inner, js::str("attachShader"));
  ctx.linkProgram = env::get_property(ctx.inner, js::str("linkProgram"));
  ctx.useProgram = env::get_property(ctx.inner, js::str("useProgram"));
  ctx.getAttribLocation = env::get_property(ctx.inner, js::str("getAttribLocation"));
  ctx.getUniformLocation = env::get_property(ctx.inner, js::str("getUniformLocation"));
  ctx.enableVertexAttribArray = env::get_property(ctx.inner, js::str("enableVertexAttribArray"));
  ctx.createTexture = env::get_property(ctx.inner, js::str("createTexture"));
  ctx.bindTexture = env::get_property(ctx.inner, js::str("bindTexture"));
  ctx.texImage2D = env::get_property(ctx.inner, js::str("texImage2D"));
  ctx.createBuffer = env::get_property(ctx.inner, js::str("createBuffer"));
  ctx.bindBuffer = env::get_property(ctx.inner, js::str("bindBuffer"));
  ctx.bufferData = env::get_property(ctx.inner, js::str("bufferData"));
  ctx.vertexAttribPointer = env::get_property(ctx.inner, js::str("vertexAttribPointer"));
  ctx.texParameteri = env::get_property(ctx.inner, js::str("texParameteri"));
  ctx.drawArrays = env::get_property(ctx.inner, js::str("drawArrays"));
  ctx.uniformMatrix3fv = env::get_property(ctx.inner, js::str("uniformMatrix3fv"));
  ctx.uniform1i = env::get_property(ctx.inner, js::str("uniform1i"));
  ctx.uniform2fv = env::get_property(ctx.inner, js::str("uniform2fv"));
  ctx.getError = env::get_property(ctx.inner, js::str("getError"));
  ctx.viewport = env::get_property(ctx.inner, js::str("viewport"));
  ctx.clearColor = env::get_property(ctx.inner, js::str("clearColor"));
  ctx.clear = env::get_property(ctx.inner, js::str("clear"));

  ctx.UNPACK_FLIP_Y_WEBGL = env::get_property(ctx.inner, js::str("UNPACK_FLIP_Y_WEBGL"));
  ctx.SRC_ALPHA = env::get_property(ctx.inner, js::str("SRC_ALPHA"));
  ctx.ONE_MINUS_SRC_ALPHA = env::get_property(ctx.inner, js::str("ONE_MINUS_SRC_ALPHA"));
  ctx.BLEND = env::get_property(ctx.inner, js::str("BLEND"));
  ctx.VERTEX_SHADER = env::get_property(ctx.inner, js::str("VERTEX_SHADER"));
  ctx.FRAGMENT_SHADER = env::get_property(ctx.inner, js::str("FRAGMENT_SHADER"));
  ctx.TEXTURE_2D = env::get_property(ctx.inner, js::str("TEXTURE_2D"));
  ctx.RGBA = env::get_property(ctx.inner, js::str("RGBA"));
  ctx.UNSIGNED_BYTE = env::get_property(ctx.inner, js::str("UNSIGNED_BYTE"));
  ctx.ARRAY_BUFFER = env::get_property(ctx.inner, js::str("ARRAY_BUFFER"));
  ctx.STATIC_DRAW = env::get_property(ctx.inner, js::str("STATIC_DRAW"));
  ctx.FLOAT = env::get_property(ctx.inner, js::str("FLOAT"));
  ctx.TEXTURE_WRAP_S = env::get_property(ctx.inner, js::str("TEXTURE_WRAP_S"));
  ctx.TEXTURE_WRAP_T = env::get_property(ctx.inner, js::str("TEXTURE_WRAP_T"));
  ctx.CLAMP_TO_EDGE = env::get_property(ctx.inner, js::str("CLAMP_TO_EDGE"));
  ctx.TEXTURE_MIN_FILTER = env::get_property(ctx.inner, js::str("TEXTURE_MIN_FILTER"));
  ctx.TEXTURE_MAG_FILTER = env::get_property(ctx.inner, js::str("TEXTURE_MAG_FILTER"));
  ctx.NEAREST = env::get_property(ctx.inner, js::str("NEAREST"));
  ctx.REPEAT = env::get_property(ctx.inner, js::str("REPEAT"));
  ctx.TRIANGLES = env::get_property(ctx.inner, js::str("TRIANGLES"));
  ctx.COLOR_BUFFER_BIT = env::get_property(ctx.inner, js::str("COLOR_BUFFER_BIT"));

  return ctx;
}

fn pixel_storei(ctx: RenderingContext, name: opaque, param: i32) {
  env::call2(ctx.inner, ctx.pixelStorei, name, env::number(param as u64));
}

fn blend_func(ctx: RenderingContext, s_factor: opaque, d_factor: opaque) {
  env::call2(ctx.inner, ctx.blendFunc, s_factor, d_factor);
}

fn enable(ctx: RenderingContext, capability: opaque) {
  env::call1(ctx.inner, ctx.enable, capability);
}

fn create_shader(ctx: RenderingContext, shader_type: opaque): Shader {
  return Shader{
    inner: env::call1(ctx.inner, ctx.createShader, shader_type),
  };
}

fn shader_source(ctx: RenderingContext, shader: Shader, source: [*]u8) {
  env::call2(ctx.inner, ctx.shaderSource, shader.inner, js::str(source));
}

fn compile_shader(ctx: RenderingContext, shader: Shader) {
  env::call1(ctx.inner, ctx.compileShader, shader.inner);
}

fn create_program(ctx: RenderingContext): Program {
  return Program{
    inner: env::call0(ctx.inner, ctx.createProgram),
  };
}

fn attach_shader(ctx: RenderingContext, program: Program, shader: Shader) {
  env::call2(ctx.inner, ctx.attachShader, program.inner, shader.inner);
}

fn link_program(ctx: RenderingContext, program: Program) {
  env::call1(ctx.inner, ctx.linkProgram, program.inner);
}

fn use_program(ctx: RenderingContext, program: Program) {
  env::call1(ctx.inner, ctx.useProgram, program.inner);
}

fn get_attrib_location(ctx: RenderingContext, program: Program, name: [*]u8): AttribLocation {
  return AttribLocation{
    inner: env::call2(ctx.inner, ctx.getAttribLocation, program.inner, js::str(name)),
  };
}

fn get_uniform_location(ctx: RenderingContext, program: Program, name: [*]u8): UniformLocation {
  return UniformLocation{
    inner: env::call2(ctx.inner, ctx.getUniformLocation, program.inner, js::str(name)),
  };
}

fn enable_vertex_attrib_array(ctx: RenderingContext, attrib_location: AttribLocation) {
  env::call1(ctx.inner, ctx.enableVertexAttribArray, attrib_location.inner);
}

fn create_texture(ctx: RenderingContext): Texture {
  return Texture {
    inner: env::call0(ctx.inner, ctx.createTexture),
  };
}

fn bind_texture(ctx: RenderingContext, target: opaque, texture: Texture) {
  env::call2(ctx.inner, ctx.bindTexture, target, texture.inner);
}

fn tex_image_2d(ctx: RenderingContext, target: opaque, level: u32, internal_format: opaque, format: opaque, type: opaque, pixels: opaque) {
  env::call6(
    ctx.inner, ctx.texImage2D,
    target,
    env::number(level as u64),
    internal_format,
    format,
    type,
    pixels,
  );
}

fn create_buffer(ctx: RenderingContext): Buffer {
  return Buffer {
    inner: env::call0(ctx.inner, ctx.createBuffer),
  };
}

fn bind_buffer(ctx: RenderingContext, target: opaque, buffer: Buffer) {
  env::call2(ctx.inner, ctx.bindBuffer, target, buffer.inner);
}

fn buffer_data(ctx: RenderingContext, target: opaque, data: opaque, usage: opaque) {
  env::call3(ctx.inner, ctx.bufferData, target, data, usage);
}

fn vertex_attrib_pointer(ctx: RenderingContext, loc: AttribLocation, size: i32, type: opaque, normalized: bool, stride: i64, offset: i64) {
  env::call6(
    ctx.inner, ctx.vertexAttribPointer,
    loc.inner, env::number(size as u64), type, env::as_bool(normalized), env::number(stride as u64), env::number(offset as u64),
  );
}

fn tex_parameteri(ctx: RenderingContext, target: opaque, pname: opaque, param: opaque) {
  env::call3(
    ctx.inner, ctx.texParameteri,
    target, pname, param,
  );
}

fn draw_arrays(ctx: RenderingContext, mode :opaque, first: u64, count: u64) {
  env::call3(
    ctx.inner, ctx.drawArrays,
    mode, env::number(first), env::number(count),
  );
}

fn uniform_matrix_3fv(ctx: RenderingContext, uniform: UniformLocation, transpose: bool, data: opaque) {
  env::call3(
    ctx.inner, ctx.uniformMatrix3fv,
    uniform.inner, env::as_bool(transpose), data,
  );
}

fn uniform_1i(ctx: RenderingContext, uniform: UniformLocation, data: i32) {
  env::call2(
    ctx.inner, ctx.uniform1i,
    uniform.inner, env::number(data as u64),
  );
}

fn uniform_2fv(ctx: RenderingContext, uniform: UniformLocation, data: opaque) {
  env::call2(
    ctx.inner, ctx.uniform2fv,
    uniform.inner, data,
  );
}

fn get_error(ctx: RenderingContext): opaque {
  return env::call0(ctx.inner, ctx.getError);
}

fn viewport(ctx: RenderingContext, x: i32, y: i32, w: i32, h: i32): opaque {
  return env::call4(
    ctx.inner, ctx.viewport,
    env::number(x as u64), env::number(y as u64), env::number(w as u64), env::number(h as u64),
  );
}

fn clear_color(ctx: RenderingContext, r: f32, g: f32, b: f32, a: f32): opaque {
  return env::call4(
    ctx.inner, ctx.clearColor,
    env::numberf32(r), env::numberf32(g), env::numberf32(b), env::numberf32(a),
  );
}

fn clear(ctx: RenderingContext, mask: opaque): opaque {
  return env::call1(
    ctx.inner, ctx.clear, mask
  );
}
