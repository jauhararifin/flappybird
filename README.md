# Flappybird

This projects clones the viral Flappy Bird game using WebAssembly and WebGL. It is written in [Magelang](https://github.com/jauhararifin/magelang).

![Flappy Bird Screenshot](./images/screenshot.png)

## Compiling

To compile this game, you must first install the Magelang compiler.

1. Before installing Magelang, make sure you have the following tools installed:
    - Git
    - [Rust](https://www.rust-lang.org/tools/install) and [Cargo](https://github.com/rust-lang/cargo)
    - [NPM](https://www.npmjs.com/) (Optional).

2. Installing magelang compiler

```bash
# At the time of writing this project, Magelang has not been officially released.
# The game was compiled using Magelang with this commit ID: 6f1192d8ccc68da05f29de4f6a6b45b3873ea26d.
# Use this commit ID to install Magelang to ensure version compatibility.
cargo install \
    --git https://github.com/jauhararifin/magelang.git \
    --rev 6f1192d8ccc68da05f29de4f6a6b45b3873ea26d \
    magelang

# Verify the installation
magelang --version
```

3. Run the build script

```bash
# Clone the flappybird repository
git clone https://github.com/jauhararifin/flappybird.git
cd flappybird

# Execute the build script:
bash ./build.sh
```

After running this script, you should see a ./build directory in your current working directory, containing all the files required to run the game.

## Running

1. Serve the build directory using an HTTP server. You can use the `http-server` package from NPM for this purpose.

```bash
npx http-server ./build  -p 8800
```

2. Open your browser and navigate to http://localhost:8800.

## Testing

To run the tests, you'll need to install a WebAssembly runtime called [wasmtime](https://wasmtime.dev/). You can follow
the installation step on their website. Wasmtime serves as a WebAssembly runtime, similar to JVM for Java and
Node.js for JavaScript. There are other alternatives such as WasmEdge, Wasmer, Wasm3, and NodeJs' own WebAssembly runtime. This
project uses wasmtime for its ease of installation and use.

Ensure that you've also installed the Magelang compiler as described in the [Compiling](#compiling) section.

To execute the tests, simply run `bash ./test.sh`.

