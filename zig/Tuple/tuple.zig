const std = @import("std");

fn print_args(values: anytype) void {
    inline for (values) |val| {
        std.debug.print("{} ", .{val});
    }
    std.debug.print("\n", .{});
}

pub fn main() void {
    print_args(.{1, 2, 3, 4});
}

