window.onload = function() {
  const canvas = document.getElementById('canvas');
  const ctx = canvas.getContext('2d');

  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;

  let memory;

  const imports = {
    'env': {
      'canvas_clear_rect': function(x, y, width, height) {
        ctx.clearRect(Number(x), Number(y), Number(width), Number(height));
      },
      'canvas_set_stroke_style': function(start, len) {
        const style = new TextDecoder().decode(new Uint8Array(memory.buffer, start, len));
        ctx.strokeStyle = style;
      },
      'canvas_set_line_width': function(width) {
        ctx.lineWidth = Number(width);
      },
      'canvas_set_fill_style': function(start, len) {
        const style = new TextDecoder().decode(new Uint8Array(memory.buffer, start, len));
        ctx.fillStyle = style;
      },
      'canvas_fill_rect': function(x, y, width, height) {
        ctx.fillRect(Number(x), Number(y), Number(width), Number(height));
      },
      'canvas_stroke_rect': function(x, y, width, height) {
        ctx.strokeRect(Number(x), Number(y), Number(width), Number(height));
      },
      'debug_i64': function(val) {
        console.log(val);
      },
      'debug_f32': function(val) {
        console.log(val);
      },
    },
  }

  WebAssembly.instantiateStreaming(fetch("/main.wasm"), imports).then(
    (results) => {
      const instance = results.instance;
      memory = instance.exports.memory;

      instance.exports.on_canvas_resized(BigInt(canvas.width), BigInt(canvas.height));
      instance.exports.on_load();

      window.onresize = function() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        instance.exports.on_canvas_resized(BigInt(canvas.width), BigInt(canvas.height));
      };

      const onEnterFrame = (ts) => {
        instance.exports.on_enter_frame(ts);
        window.requestAnimationFrame(onEnterFrame);
      };
      window.requestAnimationFrame(onEnterFrame);
    },
  );
};

