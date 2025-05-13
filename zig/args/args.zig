const std = @import("std");

pub fn main() u8 {
    var iter = std.process.args();
    while (iter.next()) |arg| {
        std.debug.print("{s}\n", .{arg});
    }
    return 0;
}
