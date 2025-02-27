# Odin + Raylib on the web
![image](https://github.com/user-attachments/assets/a104c6f4-8789-415d-a9af-c8ff2e9458ec)

Make games using Odin + Raylib that works in browser and on desktop.

Live example: https://zylinski.se/odin-raylib-web/

## Requirements

- **Emscripten**. Follow instructions here: https://emscripten.org/docs/getting_started/downloads.html (the stuff under "Installation instructions using the emsdk (recommended)").
- **Recent Odin compiler**: This uses Raylib binding changes that were done on January 1, 2025.

## Getting started

1. Point `EMSCRIPTEN_SDK_DIR` in `build_web.bat/sh` to where you installed emscripten.
2. Run `build_web.bat/sh`.
3. Web game is in the `build/web` folder.

> [!NOTE]
> `build_web.bat` is for windows, `build_web.sh` is for Linux / macOS.

> [!WARNING]
> You can't run `build/web/index.html` directly due to "CORS policy" javascript errors. You can work around that by running a small python web server:
> - Go to `build/web` in a console.
> - Run `python -m http.server`
> - Go to `localhost:8000` in your browser.
>
> _For those who don't have python: Emscripten comes with it. See the `python` folder in your emscripten installation directory._

Build a desktop executable using `build_desktop.bat/sh`. It will end up in the `build/desktop` folder.

Put any assets (textures, sounds etc) into the `assets` folder. Emscripten will merge those into the web build. For desktop builds, the `assets` folder is copied to the `build/desktop` folder.

## What works

- Use raylib, raygui, rlgl using the default `vendor:raylib` bindings.
- Allocator that works with maps and SIMD (uses emcripten's `malloc`).
- Temp allocator.
- Logger.
- `fmt.println` etc
- There's a wrapper for `read_entire_file` and `write_entire_file` from `core:os` that can files from `assets` directory, even on web. See `source/utils.odin`

> [!NOTE]
> Files written using `write_entire_file` don't exist outside the browser. They don't survive closing the tab. But you can write a file and load it within the same session. You can use it to make your old desktop code run, even though it won't be possible to _really_ save anything.

## Debugging

I recommend debugging the desktop build when you can (add `-debug` inside `build_desktop.bat/sh` and use for example [RAD Debugger](https://github.com/EpicGamesExt/raddebugger)). For web-only bugs, you can add `-g` to the the `emcc` line in the build script. This gives you better crash callstacks. It works in Chrome, not so much in Firefox.

## Sublime Text

There is a Sublime project file: `project.sublime-project`. It has a build system that lets you run the web and desktop build scripts.

## Web build in my Hot Reload template

My Odin + Raylib + Hot Reload template has been updated with similar capabilities: https://github.com/karl-zylinski/odin-raylib-hot-reload-game-template -- Note: It's just for making a _release web build_, no web hot reloading is supported!

## How does the web build work?

Start by looking at `build_web.bat/sh` and see how it uses both the Odin compiler and the emscripten compiler (`emcc`). Raylib requires `emcc` to (among other things) translate OpenGL to WebGL calls. Also see `source/main_web/index_template.html` (used as template for `build/web/index/html`). That HTML file contains javascript that calls the entry-point procedures you'll find in `source/main_web/main_web.odin`. It's a bit special in the way that it sets our Odin stuff up within a callback that comes from emscripten (`instantiateWasm`).

## Frequent Issues

### I get `panic: wasm_allocator: initial memory could not be allocated`

You probably have a global variable that allocates dynamic memory. Move that allocation into the game's `init` proc. The default context doesn't have the correct allocator set.

### Error: `emcc: error: build\web\index.data --from-emcc --preload assets' failed (returned 1)`
You might be missing the `assets` folder. It must have at least a single file inside it. You can also remove the `--preload assets` from the build script.

## Questions?

Talk to me on my Discord server: https://discord.gg/4FsHgtBmFK

## Acknowledgements
Tyzor on the Odin Discord helped me with using `js_wasm32` instead of `freestanding_wasm32`.

[Caedo's repository](https://github.com/Caedo/raylib_wasm_odin) and [Aronicu's repository](https://github.com/Aronicu/Raylib-WASM) helped me with:
- The initial emscripten setup
- The logger setup
- The idea of using python to host a server
