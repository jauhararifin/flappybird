import bitmap "bitmap";
import webgl "webgl";
import wasm "wasm";
import mem "mem";
import js "js";
import graphic "graphic";
import mat "mat";
import state "state";
import base "components/base";

struct Component{
  drawer: graphic::Drawer,
  window: js::Window,
  position_buffer: webgl::Buffer,
  tex_coord_buffer: webgl::Buffer,
  texture: webgl::Texture,

  bounding_box: *mat::Polygon,
}

@embed_file("./assets/bird.bmp")
let bird_bmp: [*]u8;

let ratio: f32 = 45.0/30.0;
let portion: f32 = 0.07;

fn setup(drawer: graphic::Drawer, window: js::Window): Component {
  let bird_texture = webgl::create_texture(drawer.ctx);
  webgl::bind_texture(drawer.ctx, drawer.ctx.TEXTURE_2D, bird_texture);

  let image = bitmap::load_image(bird_bmp);
  let image_data = bitmap::image_to_js(window, image);
  webgl::tex_image_2d(drawer.ctx, drawer.ctx.TEXTURE_2D, 0, drawer.ctx.RGBA, drawer.ctx.RGBA, drawer.ctx.UNSIGNED_BYTE, image_data);

  let position_buffer = webgl::create_buffer(drawer.ctx);
  webgl::bind_buffer(drawer.ctx, drawer.ctx.ARRAY_BUFFER, position_buffer);

  let position_data: [*]f32 = mem::alloc_array::<f32>(12);
  defer mem::dealloc_array::<f32>(position_data);
  position_data[ 0].* = -ratio; position_data[ 1].* = -1.0;
  position_data[ 2].* = -ratio; position_data[ 3].* = 1.0;
  position_data[ 4].* =  ratio; position_data[ 5].* = -1.0;
  position_data[ 6].* = -ratio; position_data[ 7].* = 1.0;
  position_data[ 8].* =  ratio; position_data[ 9].* = -1.0;
  position_data[10].* =  ratio; position_data[11].* = 1.0;
  webgl::buffer_data(drawer.ctx, drawer.ctx.ARRAY_BUFFER, js::new_f32_array(window, position_data, 12), drawer.ctx.STATIC_DRAW);

  let tex_coord_buffer = webgl::create_buffer(drawer.ctx);
  webgl::bind_buffer(drawer.ctx, drawer.ctx.ARRAY_BUFFER, tex_coord_buffer);

  let tex_coord_data: [*]f32 = mem::alloc_array::<f32>(12);
  defer mem::dealloc_array::<f32>(tex_coord_data);
  tex_coord_data[ 0].* = 0.0;     tex_coord_data[ 1].* = 0.0;
  tex_coord_data[ 2].* = 0.0;     tex_coord_data[ 3].* = 1.0;
  tex_coord_data[ 4].* = 1.0/3.0; tex_coord_data[ 5].* = 0.0;
  tex_coord_data[ 6].* = 0.0;     tex_coord_data[ 7].* = 1.0;
  tex_coord_data[ 8].* = 1.0/3.0; tex_coord_data[ 9].* = 0.0;
  tex_coord_data[10].* = 1.0/3.0; tex_coord_data[11].* = 1.0;
  webgl::buffer_data(drawer.ctx, drawer.ctx.ARRAY_BUFFER, js::new_f32_array(window, tex_coord_data, 12), drawer.ctx.STATIC_DRAW);

  let bounding_box = mem::alloc::<mat::Polygon>();
  bounding_box.* = mat::new_polygon(1);
  bounding_box.*.points[0].* = mat::vec3(0.0, 0.0, 0.0);

  return Component{
    drawer: drawer,
    window: window,
    position_buffer: position_buffer,
    tex_coord_buffer: tex_coord_buffer,
    texture: bird_texture,
    bounding_box: bounding_box,
  };
}

fn draw(c: Component, s: state::State) {
  // set position buffer
  webgl::bind_buffer(c.drawer.ctx, c.drawer.ctx.ARRAY_BUFFER, c.position_buffer);
  webgl::vertex_attrib_pointer(c.drawer.ctx, c.drawer.positionAttributeLocation, 2, c.drawer.ctx.FLOAT, false, 0, 0);

  // set texture buffer
  webgl::bind_buffer(c.drawer.ctx, c.drawer.ctx.ARRAY_BUFFER, c.tex_coord_buffer);
  webgl::vertex_attrib_pointer(c.drawer.ctx, c.drawer.textcoordAttributeLocation, 2, c.drawer.ctx.FLOAT, false, 0, 0);

  // set texture wrap and filter
  webgl::bind_texture(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.texture);
  webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_WRAP_S, c.drawer.ctx.CLAMP_TO_EDGE);
  webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_WRAP_T, c.drawer.ctx.CLAMP_TO_EDGE);
  webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_MIN_FILTER, c.drawer.ctx.NEAREST);
  webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_MAG_FILTER, c.drawer.ctx.NEAREST);

  let angle: f32 = 0.0;
  if s.stage != state::STAGE_READY {
    angle = s.speed + 2.0;
    let angleThresholdP = mat::PI / 6.0;
    let angleThresholdN = -mat::PI / 2.0;
    if angle > angleThresholdP {
      angle = angleThresholdP;
    }
    if angle < angleThresholdN {
      angle = angleThresholdN;
    }
  }

  let m1 = mat::mat3_translate(0.0, base::base_portion);
  defer mat::mat3_free(m1);
  let m2 = mat::mat3_scale(1.0 - base::base_portion, 1.0 - base::base_portion);
  defer mat::mat3_free(m2);
  let m3 = mat::mat3_translate(0.0, s.y);
  defer mat::mat3_free(m3);
  let m4 = mat::mat3_scale(portion, portion);
  defer mat::mat3_free(m4);
  let m5 = mat::mat3_scale(s.canvas_height / s.canvas_width, 1.0);
  defer mat::mat3_free(m5);
  let m6 = mat::mat3_rotate(angle);
  defer mat::mat3_free(m6);
  let m1_m2 = mat::mat3_mul(m1, m2);
  defer mat::mat3_free(m1_m2);
  let m1_m2_m3 = mat::mat3_mul(m1_m2, m3);
  defer mat::mat3_free(m1_m2_m3);
  let m1_m2_m3_m4 = mat::mat3_mul(m1_m2_m3, m4);
  defer mat::mat3_free(m1_m2_m3_m4);
  let m1_m2_m3_m4_m5 = mat::mat3_mul(m1_m2_m3_m4, m5);
  defer mat::mat3_free(m1_m2_m3_m4_m5);
  let m = mat::mat3_mul(m1_m2_m3_m4_m5, m6);
  defer mat::mat3_free(m);
  let transposed = mat::mat3_transpose(m);
  defer mat::mat3_free(transposed);
  let matrix = mat::mat3_to_js(transposed, c.window);
  webgl::uniform_matrix_3fv(c.drawer.ctx, c.drawer.transformUniform, false, matrix);

  let n_points: usize = 11;
  let bounding_box_points = mem::alloc_array::<mat::Vec3>(n_points);
  defer mem::dealloc_array::<mat::Vec3>(bounding_box_points);
  bounding_box_points[ 0].* = mat::vec3(1.0,  0.0,  1.0);
  bounding_box_points[ 1].* = mat::vec3(1.0,  0.5,  1.0);
  bounding_box_points[ 2].* = mat::vec3(0.5,  1.0,  1.0);
  bounding_box_points[ 3].* = mat::vec3(-0.2, 1.0,  1.0);
  bounding_box_points[ 4].* = mat::vec3(-1.3, 0.0,  1.0);
  bounding_box_points[ 5].* = mat::vec3(-1.3, -0.3, 1.0);
  bounding_box_points[ 6].* = mat::vec3(-0.4, -1.0, 1.0);
  bounding_box_points[ 7].* = mat::vec3(0.2,  -1.0, 1.0);
  bounding_box_points[ 8].* = mat::vec3(1.0,  -0.8, 1.0);
  bounding_box_points[ 9].* = mat::vec3(1.3,  -0.5, 1.0);
  bounding_box_points[10].* = mat::vec3(1.3,  -0.1, 1.0);

  mat::polygon_free(c.bounding_box.*);
  c.bounding_box.* = mat::new_polygon(n_points);
  for let i: usize = 0; i < n_points; i += 1 {
    let point = bounding_box_points[i].*;
    c.bounding_box.*.points[i].* = mat::mat3_mul_vec3(m, point);
  }

  for let i: usize = 0; i < n_points; i += 1 {
    mat::vec3_free(bounding_box_points[i].*);
  }

  let frame: i64 = 0;
  if s.stage == state::STAGE_RUNNING {
    frame = (s.now / 100.0) as i64 % 4;
    if frame == 3 {
      frame = 1;
    }
  } else {
    frame = 1;
  }

  // set texture translation
  let matrix_arr: [*]f32 = mem::alloc_array::<f32>(2);
  defer mem::dealloc_array::<f32>(matrix_arr);
  matrix_arr[0].* = frame as f32 / 3.0; matrix_arr[1].* = 0.0;
  let matrix = js::new_f32_array(c.window, matrix_arr, 2);
  webgl::uniform_2fv(c.drawer.ctx, c.drawer.textCoordTranslateUniform, matrix);

  // set texture mapping transformation
  let m = mat::mat3_ident();
  defer mat::mat3_free(m);
  let transposed = mat::mat3_transpose(m);
  defer mat::mat3_free(transposed);
  let matrix = mat::mat3_to_js(transposed, c.window);
  webgl::uniform_matrix_3fv(c.drawer.ctx, c.drawer.transformTextUniform, false, matrix);

  // draw
  webgl::draw_arrays(c.drawer.ctx, c.drawer.ctx.TRIANGLES, 0, 6);
}

fn get_bounding_box(c: Component): mat::Polygon {
  return c.bounding_box.*;
}

