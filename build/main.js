window.onload = function() {
  let memory;
  let func_table;
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
      'int': (n) => n,
      'func': (func_id) => {
        console.log(arguments);
        return function(...params) {
          let wasm_func = func_table.get(func_id);
          return wasm_func(...params)
        }
      },
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
      func_table = results.instance.exports.func_table;
      results.instance.exports.on_load();

      window.addEventListener('click', function(ev) {
        ev.preventDefault();
        results.instance.exports.on_click();
        return false;
      })
      window.addEventListener('touchstart', function(ev) {
        ev.preventDefault();
        results.instance.exports.on_click();
        return false;
      })
      window.addEventListener('keypress', function(ev) {
        if (ev.key !== " ") return;
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

