const std = @import("std");

// This function takes an anonymous struct (tuple-like) as an argument.
// The parameter 'args' is of type 'anytype', which allows passing any
// struct-like value, including anonymous structs like .{"foo", 123, true}
fn processTuple(args: anytype) void {
    const stdout = std.io.getStdOut().writer();

    // Access tuple elements using index notation: args[0], args[1], etc.
    // These are positional, just like tuple items.
    _ = stdout.print(
        "Tuple received:\n  - String: {}\n  - Number: {}\n  - Boolean: {}\n",
        .{ args[0], args[1], args[2] },
    );
}

pub fn main() void {
    // Define an anonymous struct (Zig's version of a tuple)
    const my_tuple = .{ "ziglang", 2025, true };

    // Call the function and pass the anonymous struct directly
    processTuple(my_tuple);

    // You can also pass it inline without assigning to a variable
    processTuple(.{ "another", 42, false });
}

