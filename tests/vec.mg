import vec "collections/vec";
import mem "mem";
import wasm "wasm";

@wasm_export("testcase_1")
fn testcase_1() {
  let v = mem::alloc::<vec::Vector<i32>>();
  vec::init::<i32>(v);

  for let k = 0; k < 100; k += 1 {
    for let i: i32 = 0; i < 100; i += 1 {
      vec::push::<i32>(v, i);
    }
    assert(vec::len::<i32>(v) == 100);
    vec::clear::<i32>(v);
    assert(vec::len::<i32>(v) == 0);
  }
}

fn assert(b: bool) {
  if !b {
    wasm::trap();
  }
}
