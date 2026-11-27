const std = @import("std");
const builtin = @import("builtin");

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

pub fn main() void {
    std.debug.print(
        "sandbox-zig ok: zig={s} os={s} arch={s} sum={d}\n",
        .{
            builtin.zig_version_string,
            @tagName(builtin.os.tag),
            @tagName(builtin.cpu.arch),
            add(20, 22),
        },
    );
}

test "add sanity check" {
    try std.testing.expectEqual(@as(i32, 42), add(20, 22));
}
