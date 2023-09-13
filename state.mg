import mat "mat";
import env "env";
import vec "collections/vec";

let STAGE_READY: i32 = 0;
let STAGE_RUNNING: i32 = 1;
let STAGE_GAMEOVER: i32 = 2;

let level_speed: f32 = 0.8;
let jump_speed: f32 = 2.0;
let gravity: f32 = -3.0 * 2.0;

struct State{
  stage: i32,

  canvas_width: f32,
  canvas_height: f32,

  gameover_ts: f32,
  start_ts: f32,
  now: f32,

  speed: f32,
  y: f32,
}

fn dist(s: State): f32 {
  let elapsed: f32 = s.now;

  // TODO: check the compiler, check why the commented code below doesn't
  // throw syntax error.
  // if (s.stage == state::STAGE_GAMEOVER)
  //   elapsed = s.gameover_ts;

  if s.stage == STAGE_GAMEOVER {
    elapsed = s.gameover_ts;
  }

  let distance: f32 = (elapsed - s.start_ts) / 1000.0 * level_speed;
  return distance;
}

fn tap(s: *State) {
  if s.stage.* == STAGE_READY {
    s.stage.* = STAGE_RUNNING;
    s.start_ts.* = s.now.*;
    s.speed.* = jump_speed;
  } else if s.stage.* == STAGE_RUNNING {
    if s.y.* < 1.0 {
      s.speed.* = jump_speed;
    }
  } else {
    if s.y.* <= -1.0 {
      s.stage.* = STAGE_READY;
      s.speed.* = 0.0;
      s.y.* = 0.0;
    }
  }
}

fn tick(s: *State, ts: f32) {
  let ds = (ts - s.now.*) / 1000.0;
  s.now.* = ts;

  if s.stage.* == STAGE_READY {
    s.y.* = mat::sin(s.now.* / 200.0) * 0.07;
  } else if s.stage.* == STAGE_RUNNING {
    s.y.* = s.y.* + s.speed.* * ds;
    s.speed.* = s.speed.* + gravity * ds;
  } else {
    if s.y.* > -1.0 {
      if s.speed.* < 0.0 {
        s.y.* = s.y.* + s.speed.* * ds;
      }
      s.speed.* = s.speed.* + gravity * ds;
    } else {
      s.y.* = -1.0 - 0.0001;
    }
  }
}

fn resize(s: *State, width: f32, height: f32) {
  s.canvas_width.* = width;
  s.canvas_height.* = height;
}

fn check_collision(
  s: *State,
  bird_box: mat::Polygon,
  pipe_boxes: *vec::Vector::<mat::Polygon>,
) {
  if s.stage.* != STAGE_RUNNING {
    return;
  }

  let is_collided = false;
  let i: usize = 0;
  while i < bird_box.n {
    let a = bird_box.points[i].*;
    let b = bird_box.points[(i + 1) % bird_box.n].*;

    let j: usize = 0;
    let pipe_boxes_len = vec::len::<mat::Polygon>(pipe_boxes);
    while j < pipe_boxes_len {
      let polygon = vec::get::<mat::Polygon>(pipe_boxes, j);
      let k: usize = 0;
      while k < polygon.n {
        let c = polygon.points[k].*;
        let d = polygon.points[(k+1)%polygon.n].*;
        is_collided = is_intersect(a, b, c, d);
        if is_collided {
          break;
        }
        k = k + 1;
      }
      if is_collided {
        break;
      }
      j = j + 1;
    }

    if is_collided {
      break;
    }

    i = i + 1;
  }

  if is_collided {
    s.stage.* = STAGE_GAMEOVER;
    s.gameover_ts.* = s.now.*;
  }
}

fn is_ccw(a: mat::Vec3, b: mat::Vec3, c: mat::Vec3): bool {
  let ax = a.v[0].*;
  let ay = a.v[1].*;
  let bx = b.v[0].*;
  let by = b.v[1].*;
  let cx = c.v[0].*;
  let cy = c.v[1].*;
  return ((cy - ay) * (bx - ax)) > ((by - ay) * (cx - ax));
}

fn is_intersect(a: mat::Vec3, b: mat::Vec3, c: mat::Vec3, d: mat::Vec3): bool {
  return (is_ccw(a, c, d) != is_ccw(b, c, d)) && (is_ccw(a, b, c) != is_ccw(a, b, d));
}

