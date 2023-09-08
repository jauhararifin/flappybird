window.onload = function() {
  const debugCanvas = document.getElementById("debug");
  const ctx = debugCanvas.getContext("2d");

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  let memory;
  const decoder = new TextDecoder();
  function newHandler(constructor, ...params) {
    return new constructor(...params);
  };
  function callHandler(self, f, ...params) {
    return f.call(self, ...params)
  }
  const imports = {
    'env': {
      'get_window': () => window,
      'get_memory': () => memory.buffer,
      'get_property': (obj, prop) => obj[prop],
      'set_property': (obj, prop, value) => { obj[prop] = value; },
      'string': (p, len) => decoder.decode(new Uint8Array(memory.buffer, Number(p), Number(len))),
      'number': (n) => Number(n),
      'numberf32': (n) => Number(n),
      'bool': (n) => Boolean(n),
      'int': (n) => BigInt(n),
      'debug': (value) => {
        console.log('debug', value);
      },
    },
  }
  for (let i = 0; i < 20; i++) {
    imports['env']['new' + i] = newHandler;
    imports['env']['call' + i] = callHandler;
  }

  WebAssembly.instantiateStreaming(fetch("/main.wasm"), imports).then(
    (results) => {
      memory = results.instance.exports.memory;
      results.instance.exports.on_load();

      window.addEventListener('resize', function() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        results.instance.exports.on_resize(canvas.width, canvas.height);
      })

      function onEnterFrame(ts) {
        results.instance.exports.on_enter_frame(ts);
        window.requestAnimationFrame(onEnterFrame);
      }
      onEnterFrame(performance.now());
    },
  );
};

