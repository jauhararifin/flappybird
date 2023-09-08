let STAGE_READY: i32 = 0;
let STAGE_RUNNING: i32 = 1;
let STAGE_GAMEOVER: i32 = 2;

let level_speed: f32 = 0.8;

struct State{
  stage: i32,

  canvas_width: f32,
  canvas_height: f32,

  gameover_ts: f32,
  start_ts: f32,
  now: f32,
}

fn dist(s: State): f32 {
  let elapsed: f32 = s.now;
  if (s.stage == state::STAGE_GAMEOVER)
    elapsed = s.gameover_ts;

  let distance: f32 = (elapsed - s.start_ts) / 1000.0 * level_speed;
  return distance;
}
