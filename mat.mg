import mem "mem";
import env "env";
import js "js";

struct Vec3 {
  v: [*]f32,
}

fn vec3(x: f32, y: f32, z: f32): Vec3 {
  let v: [*]f32 = mem::alloc_array::<f32>(3);
  v[0].* = x;
  v[1].* = y;
  v[2].* = z;
  return Vec3{v: v};
}

fn vec3_free(v: Vec3) {
  mem::dealloc_array::<f32>(v.v);
}

fn mat3_mul_vec3(m: Mat3, v: Vec3): Vec3 {
  return vec3(
    m.m[0].* * v.v[0].* + m.m[1].* * v.v[1].* + m.m[2].* * v.v[2].*,
    m.m[3].* * v.v[0].* + m.m[4].* * v.v[1].* + m.m[5].* * v.v[2].*,
    m.m[6].* * v.v[0].* + m.m[7].* * v.v[1].* + m.m[8].* * v.v[2].*,
  );
}

struct Polygon {
  points: [*]Vec3,
  n: usize,
}

fn new_polygon(n: usize): Polygon {
  let points: [*]Vec3 = mem::alloc_array::<Vec3>(n);
  return Polygon{
    points: points,
    n: n,
  };
}

fn polygon_free(p: Polygon) {
  let i: usize = 0;
  while i < p.n {
    vec3_free(p.points[i].*);
    i = i + 1;
  }
  mem::dealloc_array::<Vec3>(p.points);
}

fn polygon_to_js(window: js::Window, p: Polygon): opaque {
  let Array = env::get_property(window.inner, js::str("Array"));
  let arr = env::new0(Array);
  let push = env::get_property(arr, js::str("push"));

  let i: usize = 0;
  while i < p.n {
    let point = js::new_f32_array(window, p.points[i].*.v, 3);
    env::call1(arr, push, point);
    i = i + 1;
  }
  return arr;
}

fn mat3_mul_polygon(m: Mat3, p: Polygon) {
  let result = new_polygon(p.n);
  let i: usize = 0;
  while i < p.n {
    result.points[i].* = mat3_mul_vec3(m, result.points[i].*);
    i = i + 1;
  }
}

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

// TODO: use CORDIC method instead of taylor series.
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

// TODO: use binary search instead of linear search like this.
fn fmod(a: f32, b: f32): f32 {
  while a > b {
    a = a-b;
  }
  return a;
}
