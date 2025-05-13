const std = @import("std");
const builtin = @import("builtin");
const _os_ = builtin.os.tag;

pub fn isTuple(comptime T: type) bool {
    return @typeInfo(T) == .Struct and
        @typeInfo(T).Struct.decls.len == 0 and
        @typeInfo(T).Struct.fields.len != 0 and
        for (@typeInfo(T).Struct.fields) |field| {
            if (field.name.len != 0) return false;
        } else true;
}

