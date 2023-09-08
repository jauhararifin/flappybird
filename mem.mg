import wasm "wasm";

let page_size: usize = 65536;

fn alloc_array<T>(len: usize): [*]T {
  return alloc_size(wasm::size_of::<T>() * len) as [*]T;
}

fn alloc_size(size: usize): usize {
  let page_id = wasm::memory_grow(1);
  return page_id * page_size;
}

fn dealloc_array<T>(p: [*]T) {
}
