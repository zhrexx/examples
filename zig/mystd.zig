const std = @import("std");

var gpa_o: std.heap.GeneralPurposeAllocator(.{}) = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_o.allocator();

pub fn malloc(bytes: u32) *anyopaque {
    const header_size = @sizeOf(u32);
    const total_bytes = header_size + bytes;
    const mem = gpa.alloc(u8, total_bytes) catch @panic("BRUH buy more memory");
    std.mem.writeInt(u32, mem[0..header_size], bytes, .little);
    return @ptrCast(&mem[header_size]);
}

pub fn free(ptr: *anyopaque) void {
    const header_size = @sizeOf(u32);
    const mem_start = @as([*]u8, @ptrCast(ptr)) - header_size;
    const size = std.mem.readInt(u32, mem_start[0..header_size], .little);
    gpa.free(mem_start[0..(header_size + size)]);
}

pub fn PtrToSlice(ptr: *anyopaque) []u8 {
    const header_size = @sizeOf(u32);
    const mem_start = @as([*]u8, @ptrCast(ptr)) - header_size;
    const size = std.mem.readInt(u32, mem_start[0..header_size], .little);
    return @as([*]u8, @ptrCast(ptr))[0..size];
}

pub fn deinit_memory() void {
    gpa_o.deinit();
}

pub fn format(comptime fmt: []const u8, args: anytype) ![]u8 {
    return std.fmt.allocPrint(gpa, fmt, args);
}
