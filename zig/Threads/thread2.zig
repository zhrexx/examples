const std = @import("std");

fn sleeper(id: usize) void {
    std.debug.print("Thread {d} going to sleep for 500 ms…\n", .{id});
    std.time.sleep(500 * std.time.ns_per_ms);
    std.debug.print("Thread {d} woke up!\n", .{id});
}

pub fn main() !void {
    var t1 = try std.Thread.spawn(.{}, sleeper, .{1});
    var t2 = try std.Thread.spawn(.{}, sleeper, .{2});

    std.debug.print("Main thread is busy doing other work\n", .{});

    t1.join();
    t2.join();
}

