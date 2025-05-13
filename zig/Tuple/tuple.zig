const std = @import("std");

fn iterate_over_tuple(tuple: anytype) void {
    var i: u64 = 0;
    //const tuple_len = @typeInfo(@TypeOf(tuple)).Struct.fields.len;
    inline for (tuple) |item| {
        std.debug.print("{d} {}\n", .{i, item});
        i += 1;
        //if (tuple_len > i) std.debug.print("lul {} items left \n", .{tuple_len - i});
    }
}

pub fn main() void {
    iterate_over_tuple(.{1, 2, 3, 4});
}
