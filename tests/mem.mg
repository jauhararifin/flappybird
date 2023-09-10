import mem "mem";
import wasm "wasm";

@wasm_export("testcase_1")
fn testcase_1() {
  let arr1_f32 = mem::alloc_array::<f32>(12);
  assert(arr1_f32 as usize == 65552);
  // 65536                             65552        65600
  //     v                             v            v
  // Header{size, prev, next, is_used} content....  Footer{size, is_used}

  let arr2_f32 = mem::alloc_array::<f32>(12);
  assert(arr2_f32 as usize == 65624);
  // 65536                             65552        65600                 | 65608  65624   65672
  //     v                             v            v                     | v      v       v
  // Header{size, prev, next, is_used} content....  Footer{size, is_used} | Header content Footer

  mem::dealloc_array::<f32>(arr1_f32);
  // 65536  65552        65600  | 65608  65624   65672
  //     v  v            v      | v      v       v
  // Header ...........  Footer | Header content Footer

  let arr3_f32 = mem::alloc_array::<f32>(3);
  assert(arr3_f32 as usize == 65552);
  // 65536  65552   65564   65568  | 65576  65592   65600  | 65608  65624   65672
  //     v  v       v       v      | v      v       v      | v      v       v
  // Header content padding Footer | Header ....... Footer | Header content Footer

  let arr4_f32 = mem::alloc_array::<f32>(2);
  assert(arr4_f32 as usize == 65592);
  // 65536  65552   65564   65568  | 65576  65592   65600  | 65608  65624   65672
  //     v  v       v       v      | v      v       v      | v      v       v
  // Header content padding Footer | Header content Footer | Header content Footer
}

struct S{a: u8, b: u8, c: u8, d: u8}

@wasm_export("testcase_2")
fn testcase_2() {
  let p = mem::alloc_array::<S>(16*42); // 2688
  assert(p as usize == 65552);
  assert(mem::freelist_head as usize == 68248);
  assert(mem::freelist_head.size.* as usize == 62800);

  let arr1_f32 = mem::alloc_array::<f32>(12);
  assert(arr1_f32 as usize == 68264);
  assert(mem::freelist_head as usize == 68320);
  assert(mem::freelist_head.size.* == 62728);

  mem::dealloc_array::<f32>(arr1_f32);
  assert(mem::freelist_head as usize == 68248);
  assert(mem::freelist_head.size.* as usize == 62800);
  assert(mem::freelist_head.next.* as usize == 0);

  let arr1_f32 = mem::alloc_array::<f32>(12);
  assert(arr1_f32 as usize == 68264);
  assert(mem::freelist_head as usize == 68320);
  assert(mem::freelist_head.size.* == 62728);

  mem::dealloc_array::<f32>(arr1_f32);
  assert(mem::freelist_head as usize == 68248);
  assert(mem::freelist_head.size.* as usize == 62800);
  assert(mem::freelist_head.next.* as usize == 0);

  let m1 = mem::alloc_array::<f32>(9);
  assert(m1 as usize == 68264);
  assert(mem::freelist_head as usize == 68312);
  assert(mem::freelist_head.size.* as usize == 62736);
  assert(mem::freelist_head.next.* as usize == 0);

  let m2 = mem::alloc_array::<f32>(9);
  assert(m2 as usize == 68328);
  assert(mem::freelist_head as usize == 68376);
  assert(mem::freelist_head.size.* as usize == 62672);
  assert(mem::freelist_head.next.* as usize == 0);

  let m3 = mem::alloc_array::<f32>(9);
  assert(m3 as usize == 68392);
  assert(mem::freelist_head as usize == 68440);
  assert(mem::freelist_head.size.* as usize == 62608);
  assert(mem::freelist_head.next.* as usize == 0);

  let m4 = mem::alloc_array::<f32>(9);
  assert(m4 as usize == 68456);
  assert(mem::freelist_head as usize == 68504);
  assert(mem::freelist_head.size.* as usize == 62544);
  assert(mem::freelist_head.next.* as usize == 0);

  let m5 = mem::alloc_array::<f32>(9);
  assert(m5 as usize == 68520);
  assert(mem::freelist_head as usize == 68568);
  assert(mem::freelist_head.size.* as usize == 62480);
  assert(mem::freelist_head.next.* as usize == 0);

  let m6 = mem::alloc_array::<f32>(9);
  assert(m6 as usize == 68584);
  assert(mem::freelist_head as usize == 68632);
  assert(mem::freelist_head.size.* as usize == 62416);
  assert(mem::freelist_head.next.* as usize == 0);

  mem::dealloc_array::<f32>(m1);
  assert(mem::freelist_head as usize == 68248);
  assert(mem::freelist_head.size.* as usize == 40);
  assert(mem::freelist_head.next.* as usize == 68632);

  mem::dealloc_array::<f32>(m2);
  assert(mem::freelist_head as usize == 68248);
  assert(mem::freelist_head.size.* as usize == 104);
  assert(mem::freelist_head.next.* as usize == 68632);

  mem::dealloc_array::<f32>(m3);
  mem::dealloc_array::<f32>(m4);
  mem::dealloc_array::<f32>(m5);
  mem::dealloc_array::<f32>(m6);

  let m1 = mem::alloc_array::<f32>(2);
  mem::dealloc_array::<f32>(m1);

  let m1 = mem::alloc_array::<f32>(9);
  let m2 = mem::alloc_array::<f32>(9);
  mem::dealloc_array::<f32>(m1);
  mem::dealloc_array::<f32>(m2);

  let m1 = mem::alloc_array::<f32>(9);
  let m2 = mem::alloc_array::<f32>(9);
  let m3 = mem::alloc_array::<f32>(9);
  let m4 = mem::alloc_array::<f32>(9);
  let m5 = mem::alloc_array::<f32>(9);
  let m6 = mem::alloc_array::<f32>(9);
  mem::dealloc_array::<f32>(m1);
  mem::dealloc_array::<f32>(m2);
  mem::dealloc_array::<f32>(m3);
  mem::dealloc_array::<f32>(m4);
  mem::dealloc_array::<f32>(m5);
  mem::dealloc_array::<f32>(m6);

  let m1 = mem::alloc_array::<f32>(2);
  mem::dealloc_array::<f32>(m1);

  let m1 = mem::alloc_array::<f32>(9);
  let m2 = mem::alloc_array::<f32>(9);
  mem::dealloc_array::<f32>(m1);
  mem::dealloc_array::<f32>(m2);
}

fn assert(b: bool) {
  if !b {
    wasm::trap();
  }
}

