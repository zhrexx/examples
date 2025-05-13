const std = @import("std");

pub fn main() u8 {
    const fileName = "file.zig";
    const file = std.fs.cwd().openFile(fileName, .{}) catch @panic("could not open file");
    defer file.close();

    const content = file.readToEndAlloc(std.heap.page_allocator, 1024 * 1024) catch @panic("could not read file");
    defer std.heap.page_allocator.free(content);

    std.debug.print("File {s} content:\n{s}", .{fileName, content});

    return 0;
}
