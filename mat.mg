import mem "mem";
import js "js";

struct Mat3 {
  m: [*]f32,
}

fn mat3(
  m00: f32, m01: f32, m02: f32,
  m10: f32, m11: f32, m12: f32,
  m20: f32, m21: f32, m22: f32,
): Mat3 {
  let m: [*]f32 = mem::alloc_array::<f32>(9);
  m[0].* = m00; m[1].* = m01; m[2].* = m02;
  m[3].* = m10; m[4].* = m11; m[5].* = m12;
  m[6].* = m20; m[7].* = m21; m[8].* = m22;
  return Mat3{m: m};
}

fn mat3_free(mat3: Mat3) {
  mem::dealloc_array::<f32>(mat3.m);
}

fn mat3_get(mat3: Mat3, r: i32, c: i32): f32 {
  return mat3.m[r*3+c].*;
}

fn mat3_set(mat3: Mat3, r: i32, c: i32, val: f32) {
  mat3.m[r*3+c].* = val;
}

fn mat3_ident(): Mat3 {
  return mat3(
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
  );
}

fn mat3_translate(x: f32, y: f32): Mat3 {
  return mat3(
    1.0, 0.0, x,
    0.0, 1.0, y,
    0.0, 0.0, 1.0,
  );
}

fn mat3_scale(x: f32, y: f32): Mat3 {
  return mat3(
      x, 0.0, 0.0,
    0.0,   y, 0.0,
    0.0, 0.0, 1.0,
  );
}

fn mat3_rotate(rad: f32): Mat3 {
  return mat3(
    cos(rad), -sin(rad), 0.0,
    sin(rad),  cos(rad), 0.0,
    0.0,            0.0, 1.0,
  );
}

fn mat3_mul(a: Mat3, b: Mat3): Mat3 {
  let result = mat3(
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
  );

  let i: i32 = 0;
  while i < 3 {
    let j: i32 = 0;
    while j < 3 {
      let k: i32 = 0;
      while k < 3 {
        let x = mat3_get(result, i, j);
        let y = mat3_get(a, i, k);
        let z = mat3_get(b, k, j);
        mat3_set(result, i, j, x + y*z);
        k = k + 1;
      }
      j = j + 1;
    }
    i = i + 1;
  }

  return result;
}

fn mat3_transpose(m: Mat3): Mat3 {
  let result = mat3(
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
    0.0, 0.0, 0.0,
  );

  let i: i32 = 0;
  while i < 3 {
    let j: i32 = 0;
    while j < 3 {
      mat3_set(result, i, j, mat3_get(m, j, i));
      j = j + 1;
    }
    i = i + 1;
  }

  return result;
}

fn mat3_to_js(mat: Mat3, window: js::Window): opaque {
  return js::new_f32_array(window, mat.m, 9);
}

let PI: f32 = 3.14159265358;

fn sin(x: f32): f32 {
  x = fmod(x+PI,2.0*PI) - PI;

  let result: f32 = 0.0;
  let value: f32 = x;
  let sign: f32 = 1.0;
  let factorial: f32 = 1.0;
  let i = 0;
  while i < 10 {
    result = result + value*sign/factorial;
    sign = -sign;
    factorial = factorial * (i*2+2) as f32 * (i*2+3) as f32;
    value = value * x * x;
    i = i + 1;
  }
  return result;
}

fn cos(x: f32): f32 {
  return sin(x + PI/2.0);
}

fn fmod(a: f32, b: f32): f32 {
  while a > b {
    a = a-b;
  }
  return a;
}
