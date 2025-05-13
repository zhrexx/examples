const std = @import("std");

var gpa_o: std.heap.GeneralPurposeAllocator(.{}) = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_o.allocator();

pub fn main() u8 {
    var arr = std.ArrayList(u64).init(gpa);
    arr.append(10) catch @panic("could not append");
    
    const a: u64 = arr.pop();
    std.debug.print("{d}", .{a});
    return 0;
}
