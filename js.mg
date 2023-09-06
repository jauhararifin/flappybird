import env "env";

struct Window {
  inner: opaque,
  document: Document,
  console: Console,
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

  return Window {
    inner: inner,
    document: document,
    console: console,
  };
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
