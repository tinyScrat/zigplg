const std = @import("std");

pub fn main() !void {
    std.debug.print("Hello, {s}!\n", .{"Zig"});
}

test "Always Succeeded" {
    try std.testing.expect(true);
}
