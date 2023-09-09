import wasm "wasm";

let lower_bound: usize = 0;
let page_size: usize = 65536;
let freelist_head: *Header = 0 as *Header;

fn alloc_array<T>(len: usize): [*]T {
  return alloc_size(wasm::size_of::<T>() * len) as [*]T;
}

fn dealloc_array<T>(p: [*]T) {
  dealloc_from_ptr(p as usize);
}

struct Header{
  size: usize,
  prev: usize,
  next: usize,
  is_used: bool,
}

let header_size: usize = wasm::size_of::<Header>();

// memory layout:
// - Header: (aligned to 8 byte)
//   - size
//   - next
//   - is_used
// - padding
// - content (aligned to 8 byte)
// - padding
// - Footer (aligned to 8 byte)
//   - size
//   - is_used
// - padding

struct Footer{
  size: usize,
  is_used: bool,
}

let footer_size: usize = wasm::size_of::<Footer>();

fn alloc_size(size: usize): usize {
  let padded_size = pad(size);

  let curr = freelist_head as usize;
  while curr != 0 {
    let header = curr as *Header;
    if header.size.* >= padded_size {
      return allocate_from_chunk(header, padded_size);
    }
    curr = header.next.* as usize;
  }

  return allocate_from_new_page(size);
}

// TODO: merge neighboring free chunks together
fn dealloc_from_ptr(p: usize) {
  let padded_header = pad(header_size);
  let padded_footer = pad(footer_size);

  let header = (p - padded_header) as *Header;
  header.is_used.* = false;
  header.prev.* = 0;
  header.next.* = freelist_head as usize;
  if freelist_head as usize != 0 {
    freelist_head.prev.* = header as usize;
  }

  let footer = (p + header.size.*) as *Footer;
  footer.is_used.* = false;

  freelist_head = header;
}

fn allocate_from_chunk(header: *Header, size: usize): usize {
  let padded_header = pad(header_size);
  let padded_size = pad(size);
  let padded_footer = pad(footer_size);

  let remaining_space = header.size.* - padded_size;
  let has_additional_chunk = remaining_space >= padded_header + padded_footer + 8;
  if !has_additional_chunk {
    padded_size = padded_size + remaining_space;
  }

  header.is_used.* = true;
  header.size.* = padded_size;

  let footer_ptr = header as usize + padded_header + padded_size;
  let footer = footer_ptr as *Footer;
  footer.is_used.* = true;
  footer.size.* = padded_size;

  if has_additional_chunk {
    let remaining_header = (footer_ptr + padded_footer) as *Header;
    let remaining_content_size = remaining_space - padded_header - padded_footer;
    remaining_header.* = Header{
      size: remaining_content_size,
      prev: header.prev.* as usize,
      next: header.next.* as usize,
      is_used: false,
    };

    let remaining_footer = (remaining_header as usize + padded_header + remaining_content_size) as *Footer;
    remaining_footer.* = Footer{
      size: remaining_content_size,
      is_used: false,
    };

    if header.prev.* as usize != 0 {
      let prev_header = header.prev.* as *Header;
      prev_header.next.* = remaining_header as usize;
    }
    if header.next.* as usize != 0 {
      let next_header = header.next.* as *Header;
      next_header.prev.* = remaining_header as usize;
    }

    if header == freelist_head {
      freelist_head = remaining_header;
    }
  } else {
    if header.prev.* as usize != 0 {
      let prev_header = header.prev.* as *Header;
      prev_header.next.* = header.next.* as usize;
    }
    if header.next.* as usize != 0 {
      let next_header = header.next.* as *Header;
      next_header.prev.* = header.prev.* as usize;
    }

    if header == freelist_head {
      freelist_head = header.next.* as *Header;
    }
  }

  return header as usize + padded_header;
}

// TODO: when allocating a new page, try to merge it with neighboring chunk
fn allocate_from_new_page(size: usize): usize {
  let padded_size = pad(size);
  let padded_header = pad(header_size);
  let padded_footer = pad(footer_size);
  let total_size = padded_header + padded_size + padded_footer;
  let n_additional_pages = (total_size + page_size - 1) / page_size;

  let page_id = wasm::memory_grow(n_additional_pages);
  let p = page_id * page_size;
  if lower_bound == 0 {
    lower_bound = p;
  }
  let total_allocated = n_additional_pages * page_size;

  let remaining_space = total_allocated - total_size;
  let has_additional_chunk = remaining_space >= padded_header + padded_footer + 8;
  if !has_additional_chunk {
    padded_size = padded_size + remaining_space;
  }

  let header = p as *Header;
  header.size.* = padded_size;
  header.next.* = freelist_head as usize;
  header.prev.* = 0;
  header.is_used.* = true;

  let footer = (p + padded_header + padded_size) as *Footer;
  footer.size.* = padded_size;
  footer.is_used.* = true;

  if has_additional_chunk {
    let next_chunk = p + padded_header + padded_size + padded_footer;
    let header = next_chunk as *Header;
    header.size.* = padded_size;
    header.next.* = freelist_head as usize;
    header.prev.* = 0;
    header.is_used.* = false;

    if freelist_head as usize != 0 {
      freelist_head.prev.* = header as usize;
    }

    let remaining_content_size = remaining_space - padded_header - padded_footer;
    let footer = (next_chunk + padded_header + remaining_content_size) as *Footer;
    footer.size.* = padded_size;
    footer.is_used.* = false;

    freelist_head = header as *Header;
  }

  return p + padded_header;
}

fn pad(p: usize): usize {
  if p % 8 == 0 {
    return p;
  }
  return p + 8 - (p % 8);
}
