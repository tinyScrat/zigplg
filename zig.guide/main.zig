const std = @import("std");

pub fn main() !void {
    std.debug.print("Hello, {s}!\n", .{"Zig"});
}

test "Always Succeeded" {
    try std.testing.expect(true);
}

test "Assignment" {
    // const/var identifier: type = value;

    const constant: i32 = 5;
    var variable: u32 = 3;

    variable = @as(u32, constant);

    // type can be inferred
    const inferred = 3;
    const inferred2 = @as(i32, 34);

    _ = inferred;
    _ = inferred2;

    // variable must be assigned before using
    // undefined can be coerced to any type
    const gg: i32 = undefined;
    var hh: u32 = undefined;

    _ = gg;
    hh = 3;

    try std.testing.expect(variable == 5);
}

test "Array" {
    // array is denoted by [N]T, where N is the number of element
    // and T is the type of element, array can contains the value
    // of same type

    const a1 = [3]i32{ 1, 2, 3 };

    const a2 = [_]u8{ 'a', 'b', 'c' }; // use _ to replace length if elements is known

    try std.testing.expect(a1.len == a2.len);
}

test "if statement" {
    // using if as statement
    const a = true;
    var b: u16 = 0;
    if (a) {
        b += 1;
    } else {
        b += 2;
    }

    try std.testing.expect(b == 1);
}

test "if expression" {
    // if as expression to return value

    const a = true;
    var c: u32 = 1;
    c += if (a) 1 else 2;

    try std.testing.expect(c == 2);
}
