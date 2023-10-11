import vec "collections/vec";
import mem "mem";
import wasm "wasm";

@wasm_export("testcase_1")
fn testcase_1() {
  let v = mem::alloc::<vec::Vector<i32>>();
  vec::init::<i32>(v);

  let k = 0;
  while k < 100 {
    let i: i32 = 0;
    while i < 100 {
      vec::push::<i32>(v, i);
      i = i + 1;
    }
    assert(vec::len::<i32>(v) == 100);
    vec::clear::<i32>(v);
    assert(vec::len::<i32>(v) == 0);

    k = k + 1;
  }
}

fn assert(b: bool) {
  if !b {
    wasm::trap();
  }
}
