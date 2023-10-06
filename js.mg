import env "env";

fn as_bool(b: bool): opaque {
  return env::as_bool(b);
}

struct Window {
  inner: opaque,
  document: Document,
  console: Console,
  add_event_listener: opaque,
}

struct Document {
  inner: opaque,
  get_element_by_id: opaque,
}

struct Console {
  inner: opaque,
  log: opaque,
}

fn get_window(): Window {
  let inner = env::get_window();

  let document = Document{
    inner: env::get_property(inner, str("document")),
  };
  let get_element_by_id = env::get_property(document.inner, str("getElementById"));
  document.get_element_by_id = get_element_by_id;

  let console_inner = env::get_property(inner, str("console"));
  let console = Console{
    inner: console_inner,
  };
  let log = env::get_property(console.inner, str("log"));
  console.log = log;

  let add_event_listener = env::get_property(inner, str("addEventListener"));

  return Window {
    inner: inner,
    document: document,
    console: console,
    add_event_listener: add_event_listener,
  };
}

fn add_event_listener(window: Window, event: [*]u8, callback: fn(opaque): opaque) {
  env::call2(window.inner, window.add_event_listener, str(event), env::func(callback));
}

fn get_element_by_id(document: Document, id: [*]u8): opaque {
  return env::call1(document.inner, document.get_element_by_id, str(id));
}

fn console_log(console: Console, value: opaque) {
  env::call1(console.inner, console.log, value);
}

struct Canvas {
  inner: opaque,
}

fn new_canvas(element: opaque): Canvas {
  return Canvas{inner: element};
}

fn canvas_get_context(canvas: Canvas, name: [*]u8): opaque {
  let get_context = env::get_property(canvas.inner, str("getContext"));
  return env::call1(canvas.inner, get_context, str(name));
}

fn str(s: [*]u8): opaque {
  let strlen: usize = 0;
  while s[strlen].* != 0 {
    strlen = strlen + 1;
  }
  return env::string(s, strlen);
}

fn new_uint8_clamped_array(window: Window, buff: [*]u8, len: usize): opaque {
  let uint8ClampedArray = env::get_property(window.inner, str("Uint8ClampedArray"));
  let memory = env::get_memory();
  return env::new3(uint8ClampedArray, memory, env::number(buff as u64), env::number(len as u64));
}

fn new_f32_array(window: Window, buff: [*]f32, len: usize): opaque {
  let Float32Array = env::get_property(window.inner, str("Float32Array"));
  let memory = env::get_memory();
  return env::new3(Float32Array, memory, env::number(buff as u64), env::number(len as u64));
}
