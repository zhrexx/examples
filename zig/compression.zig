const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = "Hello, world!aaaaaaaaaaaaaaaa";
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();

    const zlib = std.compress.zlib;
    var cmp = try zlib.compressor(buf.writer(), .{});
    _ = try cmp.write(input);
    try cmp.finish();

    std.debug.print("{any} {d}\n", .{buf.items, buf.items.len});
}

