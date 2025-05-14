const channels = @import("channels.zig");
const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var channel = channels.createBoundedChannel(i32, allocator, 5);
    defer channel.deinit();
    
    const producer = try std.Thread.spawn(.{}, struct {
        fn threadFn(chan: *channels.Channel(i32)) void {
            for (0..10) |i| {
                chan.send(@intCast(i)) catch |err| {
                    std.debug.print("Producer error: {}\n", .{err});
                    return;
                };
                std.debug.print("Sent: {}\n", .{i});
                std.time.sleep(50 * std.time.ns_per_ms);
            }
            chan.close();
        }
    }.threadFn, .{&channel});
    
    while (true) {
        const value = channel.receive() catch |err| {
            if (err == channels.Channel(i32).Error.Closed) {
                std.debug.print("Channel closed, exiting\n", .{});
                break;
            }
            std.debug.print("Consumer error: {}\n", .{err});
            break;
        };
        std.debug.print("Received: {}\n", .{value});
        std.time.sleep(100 * std.time.ns_per_ms);
    }
    
    producer.join();
}
