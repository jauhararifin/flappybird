import bitmap "bitmap";
import embed "embed";
import webgl "webgl";
import mem "mem";
import js "js";
import wasm "wasm";
import graphic "graphic";
import mat "mat";
import state "state";
import base "components/base";
import pipe "components/pipe";

struct Component{
  drawer: graphic::Drawer,
  window: js::Window,
  texture: webgl::Texture,
  x_offset: [*]f32,
}

let ratio: f32 = 482.0/72.0;
let portion: f32 = 0.08;
let eps: f32 = 0.001;

fn setup(drawer: graphic::Drawer, window: js::Window): Component {
  let x_offset: [*]f32 = mem::alloc_array::<f32>(10);
  x_offset[0].* = 0.0;
  x_offset[1].* = 0.1037344398340249;
  x_offset[2].* = 0.17427385892116182;
  x_offset[3].* = 0.27800829875518673;
  x_offset[4].* = 0.3817427385892116;
  x_offset[5].* = 0.4854771784232365;
  x_offset[6].* = 0.5892116182572614;
  x_offset[7].* = 0.6929460580912863;
  x_offset[8].* = 0.7966804979253111;
  x_offset[9].* = 0.9004149377593361;

  let i = 0;
  while i < 10 {
    let next_offset: f32 = 1.0;
    if i < 9 {
      next_offset = x_offset[i+1].*;
    }

    let w = next_offset - x_offset[i].*;
    let r = ratio * w;

    let position_data: [*]f32 = mem::alloc_array::<f32>(12);
    position_data[ 0].* = -r; position_data[ 1].* = -1.0;
    position_data[ 2].* = -r; position_data[ 3].* = 1.0;
    position_data[ 4].* =  r; position_data[ 5].* = -1.0;
    position_data[ 6].* = -r; position_data[ 7].* = 1.0;
    position_data[ 8].* =  r; position_data[ 9].* = -1.0;
    position_data[10].* =  r; position_data[11].* = 1.0;
    let position_buffer = webgl::create_buffer(drawer.ctx);
    webgl::bind_buffer(drawer.ctx, drawer.ctx.ARRAY_BUFFER, position_buffer);
    webgl::buffer_data(drawer.ctx, drawer.ctx.ARRAY_BUFFER, js::new_f32_array(window, position_data, 12), drawer.ctx.STATIC_DRAW);
    mem::dealloc_array::<f32>(position_data);

    let tex_coord_data: [*]f32 = mem::alloc_array::<f32>(12);
    tex_coord_data[ 0].* = x_offset[i].*;     tex_coord_data[ 1].* = 0.0;
    tex_coord_data[ 2].* = x_offset[i].*;     tex_coord_data[ 3].* = 1.0;
    tex_coord_data[ 4].* = next_offset - eps; tex_coord_data[ 5].* = 0.0;
    tex_coord_data[ 6].* = x_offset[i].*;     tex_coord_data[ 7].* = 1.0;
    tex_coord_data[ 8].* = next_offset - eps; tex_coord_data[ 9].* = 0.0;
    tex_coord_data[10].* = next_offset - eps; tex_coord_data[11].* = 1.0;
    let tex_coord_buffer = webgl::create_buffer(drawer.ctx);
    webgl::bind_buffer(drawer.ctx, drawer.ctx.ARRAY_BUFFER, tex_coord_buffer);
    webgl::buffer_data(drawer.ctx, drawer.ctx.ARRAY_BUFFER, js::new_f32_array(window, tex_coord_data, 12), drawer.ctx.STATIC_DRAW);
    mem::dealloc_array::<f32>(tex_coord_data);

    wasm::table_set( 0 + i as usize, position_buffer.inner);
    wasm::table_set(10 + i as usize, tex_coord_buffer.inner);

    i = i + 1;
  }

  let texture = webgl::create_texture(drawer.ctx);
  webgl::bind_texture(drawer.ctx, drawer.ctx.TEXTURE_2D, texture);
  let image = bitmap::load_image(embed::digits_bmp);
  let image_data = bitmap::image_to_js(window, image);
  webgl::tex_image_2d(drawer.ctx, drawer.ctx.TEXTURE_2D, 0, drawer.ctx.RGBA, drawer.ctx.RGBA, drawer.ctx.UNSIGNED_BYTE, image_data);

  return Component{
    x_offset: x_offset,
    drawer: drawer,
    window: window,
    texture: texture,
  };
}

fn draw(c: Component, s: state::State) {
  if s.stage == state::STAGE_READY {
    return;
  }

  let distance = state::dist(s);
  let score = wasm::floor_f32((distance - pipe::first_obstacle_distance)/pipe::obstacle_gap) as i32 + 1;
  if score < 0 {
    score = 0;
  }

  let digits = mem::alloc_array::<i32>(10);
  let n_digits = 0;
  if score == 0 {
    digits[n_digits].* = 0;
    n_digits = n_digits + 1;
  } else {
    while score > 0 {
      digits[n_digits].* = score % 10;
      n_digits = n_digits + 1;
      score = score / 10;
    }
  }
  let i = 0;
  while i < n_digits / 2 {
    let tmp = digits[i].*;
    digits[i].* = digits[n_digits-1-i].*;
    digits[n_digits-1-i].* = tmp;
    i = i + 1;
  }

  let total_width: f32 = 0.0;
  let i = 0;
  while i < n_digits {
    let digit = digits[i].*;
    let x0 = c.x_offset[digit].*;
    let x1: f32 = 1.0;
    if digit < 9 {
      x1 = c.x_offset[digit+1].*;
    }
    let w = x1 - x0;
    total_width = total_width + w * ratio * 2.0;

    i = i + 1;
  }

  let i = 0;
  let offset: f32 = 0.0;
  while i < n_digits {
    let digit = digits[i].*;

    // set position buffer
    let position_buffer = webgl::Buffer{inner: wasm::table_get( 0 + digit as usize)};
    webgl::bind_buffer(c.drawer.ctx, c.drawer.ctx.ARRAY_BUFFER, position_buffer);
    webgl::vertex_attrib_pointer(c.drawer.ctx, c.drawer.positionAttributeLocation, 2, c.drawer.ctx.FLOAT, false, 0, 0);

    // set texture buffer
    let tex_coord_buffer = webgl::Buffer{inner: wasm::table_get(10 + digit as usize)};
    webgl::bind_buffer(c.drawer.ctx, c.drawer.ctx.ARRAY_BUFFER, tex_coord_buffer);
    webgl::vertex_attrib_pointer(c.drawer.ctx, c.drawer.textcoordAttributeLocation, 2, c.drawer.ctx.FLOAT, false, 0, 0);

    // sex texture properties
    webgl::bind_texture(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.texture);
    webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_WRAP_S, c.drawer.ctx.CLAMP_TO_EDGE);
    webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_WRAP_T, c.drawer.ctx.CLAMP_TO_EDGE);
    webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_MIN_FILTER, c.drawer.ctx.NEAREST);
    webgl::tex_parameteri(c.drawer.ctx, c.drawer.ctx.TEXTURE_2D, c.drawer.ctx.TEXTURE_MAG_FILTER, c.drawer.ctx.NEAREST);

    let x0 = c.x_offset[digit].*;
    let x1: f32 = 1.0;
    if digit < 9 {
      x1 = c.x_offset[digit+1].*;
    }
    let w = x1 - x0;

    // creating transformation matrix
    let m1 = mat::mat3_translate(0.0, 0.6);
    let m2 = mat::mat3_scale(portion, portion);
    let m3 = mat::mat3_scale(s.canvas_height/s.canvas_width, 1.0);
    let m4 = mat::mat3_translate(-total_width/2.0+offset, 0.0);
    let m5 = mat::mat3_translate(w*ratio, 0.0);
    let m1_m2 = mat::mat3_mul(m1, m2);
    let m1_m2_m3 = mat::mat3_mul(m1_m2, m3);
    let m1_m2_m3_m4 = mat::mat3_mul(m1_m2_m3, m4);
    let m1_m2_m3_m4_m5 = mat::mat3_mul(m1_m2_m3_m4, m5);
    let transposed = mat::mat3_transpose(m1_m2_m3_m4_m5);
    let matrix = mat::mat3_to_js(transposed, c.window);
    mat::mat3_free(m1);
    mat::mat3_free(m2);
    mat::mat3_free(m3);
    mat::mat3_free(m4);
    mat::mat3_free(m5);
    mat::mat3_free(m1_m2);
    mat::mat3_free(m1_m2_m3);
    mat::mat3_free(m1_m2_m3_m4);
    mat::mat3_free(m1_m2_m3_m4_m5);
    mat::mat3_free(transposed);
    webgl::uniform_matrix_3fv(c.drawer.ctx, c.drawer.transformUniform, false, matrix);

    // set texture translation
    let matrix_arr: [*]f32 = mem::alloc_array::<f32>(2);
    matrix_arr[0].* = 0.0; matrix_arr[1].* = 0.0;
    let matrix = js::new_f32_array(c.window, matrix_arr, 2);
    mem::dealloc_array::<f32>(matrix_arr);
    webgl::uniform_2fv(c.drawer.ctx, c.drawer.textCoordTranslateUniform, matrix);

    // set texture mapping transformation
    let m = mat::mat3_ident();
    let matrix = mat::mat3_to_js(m, c.window);
    mat::mat3_free(m);
    webgl::uniform_matrix_3fv(c.drawer.ctx, c.drawer.transformTextUniform, false, matrix);

    // draw
    webgl::draw_arrays(c.drawer.ctx, c.drawer.ctx.TRIANGLES, 0, 6);

    offset = offset + w * ratio * 2.0;
    i = i + 1;
  }

  mem::dealloc_array::<i32>(digits);
}

