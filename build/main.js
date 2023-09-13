window.onload = function() {
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
  function debugHandler(...params) {
    return console.log(...params)
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
    imports['env']['debug' + i] = debugHandler;
  }

  WebAssembly.instantiateStreaming(fetch("/main.wasm"), imports).then(
    (results) => {
      memory = results.instance.exports.memory;
      results.instance.exports.on_load();
      results.instance.exports.on_resize(canvas.width, canvas.height);

      window.addEventListener('resize', function() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        results.instance.exports.on_resize(canvas.width, canvas.height);
      })
      let flag = false;
      window.addEventListener('click', function() {
        if (flag) return; flag = true; setTimeout(() => { flag = false }, 100);
        results.instance.exports.on_click();
        return false;
      })
      window.addEventListener('touchstart', function() {
        if (flag) return; flag = true; setTimeout(() => { flag = false }, 100);
        results.instance.exports.on_click();
        return false;
      })
      window.addEventListener('keypress', function(ev) {
        if (ev.key !== " ") return;
        if (flag) return; flag = true; setTimeout(() => { flag = false }, 100);
        results.instance.exports.on_click();
        return false;
      })

      function onEnterFrame(ts) {
        results.instance.exports.on_enter_frame(ts);
        window.requestAnimationFrame(onEnterFrame);
      }
      onEnterFrame(performance.now());
    },
  );
};

