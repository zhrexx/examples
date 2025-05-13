const std = @import("std");
const json = std.json;
const os = std.os;

var gpa_o: std.heap.GeneralPurposeAllocator(.{}) = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_o.allocator();
const out = std.io.getStdOut().writer();

fn print(comptime fmt: []const u8, args: anytype) void {
    out.print(fmt, args) catch @panic("could not print");
}

fn getField(table: json.Value, fieldName: []const u8) json.Value {
    return table.object.get(fieldName).?;
}

pub fn main() u8 {
    const json_data = \\{
        \\  "name": "Zig",
        \\  "version": 0.14,
        \\  "features": ["safety", "performance", "simplicity"],
        \\  "is_stable": false
        \\}
    ;

    const parsed = std.json.parseFromSlice(json.Value, gpa, json_data, .{}) catch @panic("could not parse json");
    defer parsed.deinit();
    const root = parsed.value;
    
    const name_val      = getField(root, "name").string;
    const version_val   = getField(root, "version").float;
    const features_arr  = getField(root, "features").array;
    const is_stable_val = getField(root, "is_stable").bool;
    

    print("Name: {s}\n", .{name_val});
    print("Version: {any}\n", .{version_val});
    print("Features:\n", .{});
    for (features_arr.items) |feature| {
        print("  - {s}\n", .{feature.string});
    }
    print("Is stable: {any}\n", .{is_stable_val});

    return 0;
}
