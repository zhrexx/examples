const std = @import("std");

pub fn backgroundTask(msg: u64) void {
    std.time.sleep(500 * std.time.ns_per_ms);
    std.debug.print("{d}\n", .{msg});
}

pub fn main() !void {
    var bgThread = try std.Thread.spawn(.{}, backgroundTask, .{100});
    bgThread.detach();
}
