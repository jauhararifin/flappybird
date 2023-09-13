import wasm "wasm";
import bitmap "bitmap";
import embed "embed";
import webgl "webgl";
import mem "mem";
import js "js";
import env "env";
import graphic "graphic";
import mat "mat";
import state "state";
import base "components/base";
import vec "collections/vec";

struct Component{
  drawer: graphic::Drawer,
  window: js::Window,
  position_buffer: webgl::Buffer,
  tex_coord_buffer: webgl::Buffer,
  texture: webgl::Texture,

  bounding_boxes: *vec::Vector::<mat::Polygon>,
}

let ratio: f32 = 52.0/320.0;
let portion: f32 = 1.0;
let first_obstacle_distance: f32 = 0.8*5.0;
let obstacle_gap: f32 = 1.2;
let obstacle_height: f32 = 0.7;

fn setup(drawer: graphic::Drawer, window: js::Window): Component {
  let pipe_texture = webgl::create_texture(drawer.ctx);
  webgl::bind_texture(drawer.ctx, drawer.ctx.TEXTURE_2D, pipe_texture);

  let image = bitmap::load_image(embed::pipe_bmp);
  let image_data = bitmap::image_to_js(window, image);
  webgl::tex_image_2d(drawer.ctx, drawer.ctx.TEXTURE_2D, 0, drawer.ctx.RGBA, drawer.ctx.RGBA, drawer.ctx.UNSIGNED_BYTE, image_data);

  let position_buffer = webgl::create_buffer(drawer.ctx);
  webgl::bind_buffer(drawer.ctx, drawer.ctx.ARRAY_BUFFER, position_buffer);

  let position_data: [*]f32 = mem::alloc_array::<f32>(12);
  position_data[ 0].* = -ratio; position_data[ 1].* = -1.0;
  position_data[ 2].* = -ratio; position_data[ 3].* = 1.0;
  position_data[ 4].* =  ratio; position_data[ 5].* = -1.0;
  position_data[ 6].* = -ratio; position_data[ 7].* = 1.0;
  position_data[ 8].* =  ratio; position_data[ 9].* = -1.0;
  position_data[10].* =  ratio; position_data[11].* = 1.0;
  webgl::buffer_data(drawer.ctx, drawer.ctx.ARRAY_BUFFER, js::new_f32_array(window, position_data, 12), drawer.ctx.STATIC_DRAW);
  mem::dealloc_array::<f32>(position_data);

  let tex_coord_buffer = webgl::create_buffer(drawer.ctx);
  webgl::bind_buffer(drawer.ctx, drawer.ctx.ARRAY_BUFFER, tex_coord_buffer);

  let tex_coord_data: [*]f32 = mem::alloc_array::<f32>(12);
  tex_coord_data[ 0].* = 0.0; tex_coord_data[ 1].* = 0.0;
  tex_coord_data[ 2].* = 0.0; tex_coord_data[ 3].* = 1.0;
  tex_coord_data[ 4].* = 1.0; tex_coord_data[ 5].* = 0.0;
  tex_coord_data[ 6].* = 0.0; tex_coord_data[ 7].* = 1.0;
  tex_coord_data[ 8].* = 1.0; tex_coord_data[ 9].* = 0.0;
  tex_coord_data[10].* = 1.0; tex_coord_data[11].* = 1.0;
  webgl::buffer_data(drawer.ctx, drawer.ctx.ARRAY_BUFFER, js::new_f32_array(window, tex_coord_data, 12), drawer.ctx.STATIC_DRAW);
  mem::dealloc_array::<f32>(tex_coord_data);

  let bounding_boxes = mem::alloc::<vec::Vector::<mat::Polygon>>();
  vec::init::<mat::Polygon>(bounding_boxes);

  return Component{
    drawer: drawer,
    window: window,
    position_buffer: position_buffer,
    tex_coord_buffer: tex_coord_buffer,
    texture: pipe_texture,

    bounding_boxes: bounding_boxes,
  };
}

fn draw(c: Component, s: state::State) {
  if s.stage == state::STAGE_READY {
    return;
  }

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

  // set texture translation
  let matrix_arr: [*]f32 = mem::alloc_array::<f32>(2);
  matrix_arr[0].* = 0.0; matrix_arr[1].* = 0.0;
  let matrix = js::new_f32_array(c.window, matrix_arr, 2);
  mem::dealloc_array::<f32>(matrix_arr);
  webgl::uniform_2fv(c.drawer.ctx, c.drawer.textCoordTranslateUniform, matrix);

  // set texture mapping transformation
  let m = mat::mat3_ident();
  let transposed = mat::mat3_transpose(m);
  let matrix = mat::mat3_to_js(transposed, c.window);
  mat::mat3_free(m);
  mat::mat3_free(transposed);
  webgl::uniform_matrix_3fv(c.drawer.ctx, c.drawer.transformTextUniform, false, matrix);

  let bounding_box_points = mem::alloc_array::<mat::Vec3>(8);
  bounding_box_points[0].* = mat::vec3(-0.16,  1.0, 1.0);
  bounding_box_points[1].* = mat::vec3( 0.16,  1.0, 1.0);
  bounding_box_points[2].* = mat::vec3( 0.16, 0.85, 1.0);
  bounding_box_points[3].* = mat::vec3( 0.15, 0.85, 1.0);
  bounding_box_points[4].* = mat::vec3( 0.15, -1.0, 1.0);
  bounding_box_points[5].* = mat::vec3(-0.15, -1.0, 1.0);
  bounding_box_points[6].* = mat::vec3(-0.15, 0.85, 1.0);
  bounding_box_points[7].* = mat::vec3(-0.16, 0.85, 1.0);
  let n_points: usize = 8;

  // TODO: currently, we need to deallocate the vector items because we can't
  // pass the deallocate function yet (we don't have function type yet).
  let i: usize = 0;
  while i < vec::len::<mat::Polygon>(c.bounding_boxes) {
    mat::polygon_free(vec::get::<mat::Polygon>(c.bounding_boxes, i));
    i = i + 1;
  }
  vec::clear::<mat::Polygon>(c.bounding_boxes);

  let distance: f32 = state::dist(s);
  let dist_range_x0 = -(s.canvas_width / s.canvas_height)/2.0 + distance - 1.0;
  let dist_range_x1 = +(s.canvas_width / s.canvas_height)/2.0 + distance + 1.0;
  let k0 = wasm::floor_f32((dist_range_x0 - first_obstacle_distance) / obstacle_gap);
  if k0 < 0.0 {
    k0 = 0.0;
  }
  let k1 = wasm::ceil_f32((dist_range_x1 - first_obstacle_distance) / obstacle_gap);

  let i = k0;
  while i <= k1 {
    let x = first_obstacle_distance + i * obstacle_gap - distance;
    let y: f32 = randomize(wasm::floor_f32(i) as i32, s.start_ts) as f32 / 4294967296.0 * 0.8 - 0.4;

    // draw bottom pipe
    let m1 = mat::mat3_translate(0.0, base::base_portion);
    let m2 = mat::mat3_scale(1.0 - base::base_portion, 1.0 - base::base_portion);
    let m3 = mat::mat3_scale(portion, portion);
    let m4 = mat::mat3_scale(s.canvas_height / s.canvas_width, 1.0);
    let m5 = mat::mat3_translate(x, y - obstacle_height / 2.0);
    let m6 = mat::mat3_translate(0.0, -1.0);
    let m1_m2 = mat::mat3_mul(m1, m2);
    let m1_m2_m3 = mat::mat3_mul(m1_m2, m3);
    let m1_m2_m3_m4 = mat::mat3_mul(m1_m2_m3, m4);
    let m1_m2_m3_m4_m5 = mat::mat3_mul(m1_m2_m3_m4, m5);
    let m = mat::mat3_mul(m1_m2_m3_m4_m5, m6);
    let transposed = mat::mat3_transpose(m);
    let matrix = mat::mat3_to_js(transposed, c.window);
    mat::mat3_free(m1);
    mat::mat3_free(m2);
    mat::mat3_free(m3);
    mat::mat3_free(m4);
    mat::mat3_free(m5);
    mat::mat3_free(m6);
    mat::mat3_free(m1_m2);
    mat::mat3_free(m1_m2_m3);
    mat::mat3_free(m1_m2_m3_m4);
    mat::mat3_free(m1_m2_m3_m4_m5);
    mat::mat3_free(transposed);
    webgl::uniform_matrix_3fv(c.drawer.ctx, c.drawer.transformUniform, false, matrix);
    webgl::draw_arrays(c.drawer.ctx, c.drawer.ctx.TRIANGLES, 0, 6);

    let j: usize = 0;
    let polygon = mat::new_polygon(n_points);
    while j < n_points {
      let point = bounding_box_points[j].*;
      polygon.points[j].* = mat::mat3_mul_vec3(m, point);
      j = j + 1;
    }
    vec::push::<mat::Polygon>(c.bounding_boxes, polygon);
    mat::mat3_free(m);

    // draw top pipe
    let m1 = mat::mat3_translate(0.0, base::base_portion);
    let m2 = mat::mat3_scale(1.0 - base::base_portion, 1.0 - base::base_portion);
    let m3 = mat::mat3_scale(portion, portion);
    let m4 = mat::mat3_scale(s.canvas_height / s.canvas_width, 1.0);
    let m5 = mat::mat3_translate(x, y + obstacle_height / 2.0);
    let m6 = mat::mat3_scale(1.0, -1.0);
    let m7 = mat::mat3_translate(0.0, -1.0);
    let m1_m2 = mat::mat3_mul(m1, m2);
    let m1_m2_m3 = mat::mat3_mul(m1_m2, m3);
    let m1_m2_m3_m4 = mat::mat3_mul(m1_m2_m3, m4);
    let m1_m2_m3_m4_m5 = mat::mat3_mul(m1_m2_m3_m4, m5);
    let m1_m2_m3_m4_m5_m6 = mat::mat3_mul(m1_m2_m3_m4_m5, m6);
    let m = mat::mat3_mul(m1_m2_m3_m4_m5_m6, m7);
    let transposed = mat::mat3_transpose(m);
    let matrix = mat::mat3_to_js(transposed, c.window);
    mat::mat3_free(m1);
    mat::mat3_free(m2);
    mat::mat3_free(m3);
    mat::mat3_free(m4);
    mat::mat3_free(m5);
    mat::mat3_free(m6);
    mat::mat3_free(m7);
    mat::mat3_free(m1_m2);
    mat::mat3_free(m1_m2_m3);
    mat::mat3_free(m1_m2_m3_m4);
    mat::mat3_free(m1_m2_m3_m4_m5);
    mat::mat3_free(m1_m2_m3_m4_m5_m6);
    mat::mat3_free(transposed);
    webgl::uniform_matrix_3fv(c.drawer.ctx, c.drawer.transformUniform, false, matrix);
    webgl::draw_arrays(c.drawer.ctx, c.drawer.ctx.TRIANGLES, 0, 6);

    let j: usize = 0;
    let polygon = mat::new_polygon(n_points);
    while j < n_points {
      let point = bounding_box_points[j].*;
      polygon.points[j].* = mat::mat3_mul_vec3(m, point);
      j = j + 1;
    }
    vec::push::<mat::Polygon>(c.bounding_boxes, polygon);
    mat::mat3_free(m);

    i = i + 1.0;
  }

  let i: usize = 0;
  while i < n_points {
    mat::vec3_free(bounding_box_points[i].*);
    i = i + 1;
  }
  mem::dealloc_array::<mat::Vec3>(bounding_box_points);
}

fn get_bounding_boxes(c: Component): *vec::Vector::<mat::Polygon> {
  return c.bounding_boxes;
}

// randomize creates random number deterministically based on i and f
// currently, it uses crc32 to randomize the number
// TODO: consider using mersenne twister as PRNG.
fn randomize(i: i32, f: f32): u32 {
  let f = wasm::floor_f32(f) as u32;
  return crc32(f) ^ crc32(i as u32);
}

fn crc32(payload: u32): u32 {
  let crc: u32 = 4294967295;

  let i = 0;
  while i < 4 {
    let byte = payload as u8;
    payload = payload >> 8;
    crc = crc ^ (byte as u32);
    let j = 7;
    while j >= 0 {
      let mask = -(crc & 1);
      crc = (crc >> 1) ^ (3988292384 & mask);
      j = j - 1;
    }
    i = i + 1;
  }

  return ~crc;
}
