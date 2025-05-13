const std = @import("std");

fn example_thread_fn(context: *u32, aboba: u8) void {
    std.debug.print("Hello from thread! Value = {} {}\n", .{context.*, aboba});
}

pub fn main() u8 {
    var value: u32 = 1000;
    const handle = std.Thread.spawn(.{}, example_thread_fn, .{&value, 10}) catch @panic("could not create thread");
    handle.join();
    return 0;
}
