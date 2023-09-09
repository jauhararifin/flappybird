import mem "mem";
import js "js";
import env "env";

// contains the header fields, file size and reserved field
// offset  size
// 0       2    The header field to identify BMP and DIB file.
// 2       4    The size of bmp file;
// 6       2    Reserved
// 8       2    Reserved
// 10      4    Offset to starting address of pixel array

// DIB header
// offset  size
// 18      4    The bitmap width in pixels (signed integer)
// 22      4    The bitmap height in pixels (signed integer)
// 28      2    The number of bits per pixel

struct Image {
  width: u64,
  height: u64,
  pixels: [*]Color,
}

struct Color {
  r: u8,
  g: u8,
  b: u8,
  a: u8,
}

fn load_image(buff: [*]u8): Image {
  let width = read_u32(buff[18] as [*]u8) as u64;
  let height = read_u32(buff[22] as [*]u8) as u64;

  let pixel_p = (read_u32(buff[10] as [*]u8) + (buff as u32)) as [*]u8;

  let bits_per_pixel = (buff[28] as *u16).*;
  if bits_per_pixel != 32 {
    return Image{};
  }

  let pixels = mem::alloc_array::<Color>((width * height) as usize);
  let row_size = width * 4;
  let x: u64 = 0;
  let y: u64 = 0;
  while y < height {
    x = 0;
    while x < width {
      let b = pixel_p[y * row_size + x*4 + 0].*;
      let g = pixel_p[y * row_size + x*4 + 1].*;
      let r = pixel_p[y * row_size + x*4 + 2].*;
      let a = pixel_p[y * row_size + x*4 + 3].*;
      let color = Color{r: r, g: g, b: b, a: a};

      let yy = height-1-y;
      pixels[yy*width + x].* = color;
      x = x + 1;
    }
    y = y + 1;
  }


  return Image{
    width: width,
    height: height,
    pixels: pixels,
  };
}

fn read_u32(p: [*]u8): u32 {
  return (p[0].* as u32) | (p[1].* as u32 << 8) | (p[2].* as u32 << 16) | (p[3].* as u32 << 24);
}

fn image_to_js(window: js::Window, image: Image): opaque {
  let size = image.width * image.height * 4;
  let data = js::new_uint8_clamped_array(window, image.pixels as [*]u8, size as usize);

  let image_data = env::get_property(window.inner, js::str("ImageData"));
  return env::new3(image_data, data, env::number(image.width), env::number(image.height));
}
