import mat "mat";
import env "env";

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
    s.now.* = 0.0;
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
    }
    s.speed.* = s.speed.* + gravity * ds;
  }
}

fn resize(s: *State, width: f32, height: f32) {
  s.canvas_width.* = width;
  s.canvas_height.* = height;
}

