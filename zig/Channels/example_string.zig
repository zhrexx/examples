const channels = @import("channels.zig");
const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var channel = channels.createBoundedChannel([]const u8, allocator, 5);
    defer channel.deinit();
    
    const producer = try std.Thread.spawn(.{}, struct {
        fn threadFn(chan: *channels.Channel([]const u8)) void {
            const aboba: []const u8 = "Hello, World";
            for (0..10) |i|{
                _ = i;
                chan.send(aboba) catch |err| {
                    std.debug.print("Producer error: {}\n", .{err});
                    return;
                };
                std.debug.print("Sent: {s}\n", .{aboba});
                std.time.sleep(50 * std.time.ns_per_ms);
            }
            chan.close();
        }
    }.threadFn, .{&channel});
    
    while (true) {
        const value = channel.receive() catch |err| {
            if (err == channels.Channel([]const u8).Error.Closed) {
                std.debug.print("Channel closed, exiting\n", .{});
                break;
            }
            std.debug.print("Consumer error: {}\n", .{err});
            break;
        };
        std.debug.print("Received: {s}\n", .{value});
        std.time.sleep(100 * std.time.ns_per_ms);
    }
    
    producer.join();
}
