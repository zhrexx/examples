const std = @import("std");
const rl = @import("raylib");

pub fn main() !u8 {
    rl.setConfigFlags(rl.ConfigFlags{.window_resizable = true});
    var windowWidth: i32 = 1600;
    var windowHeight: i32 = 800;
    rl.initWindow(windowWidth, windowHeight, "Hello, World");
    
    while (!rl.windowShouldClose()) {
        if (rl.isWindowResized()) {
            windowWidth = rl.getScreenWidth();
            windowHeight = rl.getScreenHeight();
        }
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.red);
    }
    return 0;
}

